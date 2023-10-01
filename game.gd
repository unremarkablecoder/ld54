extends Node2D

var ship: RigidBody2D
var player_vars
var people_transferring = []
var transfer_timer = 0.5
var pod: Node2D
var dead = false
var dead_timer = 0
@export var hit_sound: AudioStreamPlayer
@export var die_sound: AudioStreamPlayer
@export var pickup_sound: AudioStreamPlayer
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	player_vars = $"/root/PlayerVars"
	ship = $ship
	ship.hit_wall.connect(on_ship_hit_wall)
	load_level(player_vars.current_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_vars.level_timer += delta
	if dead:
		dead_timer += delta
		if dead_timer > 0.02:
			if ship.visible:
				ship.visible = false
				die_sound.play()
				var ship_destroy = load("res://ship/ship_destroy.tscn").instantiate()
				ship_destroy.global_transform = ship.global_transform
				add_child(ship_destroy)
			if Engine.time_scale < 1:
				Engine.time_scale += 10 * delta
		
		if dead_timer > 1:
			player_vars.level_lost = true
			get_tree().change_scene_to_file("res://menu/menu.tscn")	
			

func load_level(level_number):
	var level = load("res://levels/level_%d.tscn" % level_number).instantiate()
	var start_pos = level.get_node("start_pos")
	pod = level.get_node("pod")
	var docking_area: Area2D = level.get_node("pod/docking_area")
	docking_area.body_entered.connect(on_docking_area_body_entered)
	docking_area.body_exited.connect(on_docking_area_body_exited)
	var leave_area: Area2D = level.get_node("leave_area")
	leave_area.body_entered.connect(on_leave_area_body_entered)
	add_child(level)
	ship.global_transform = start_pos.global_transform
	reset_level_player_vars()
	
	
func reset_level_player_vars():
	player_vars.level_won = false
	player_vars.level_lost = false
	player_vars.hull_integrity = 100
	player_vars.people_in_pod = 10
	player_vars.people_dead = 0
	player_vars.people_on_ship = 0
	player_vars.level_timer = 0

func on_docking_area_body_entered(body):
	ship.in_docking_area = true

func on_docking_area_body_exited(body):
	ship.in_docking_area = false

func on_ship_hit_wall(force):
	hit_sound.play()
	player_vars.hull_integrity -= 1 + int(force * 0.5)
	if player_vars.hull_integrity <= 0:
		die()
	elif player_vars.people_on_ship > 0:
		var drop_chance = 1 - player_vars.hull_integrity * 0.01 * 0.5
		var roll = rng.randf()
		if roll < drop_chance:
			player_vars.people_on_ship -= 1
			player_vars.people_dead += 1
			var person = load("res://ship/person.tscn").instantiate()
			person.global_position = ship.global_position
			add_child(person)
			var tween = create_tween()
			var target_pos = ship.global_position + ship.linear_velocity.normalized() * 2000# Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized() * 2000
			tween.tween_property(person, "global_position", target_pos, 1)
			tween.tween_callback(person.queue_free)
		

func _physics_process(delta):
	handle_people_transfer(delta)
	
	if not ship.in_docking_area:
		pod.set_light(false, player_vars.people_in_pod > 0, false)
		return
		
	if ship.linear_velocity.length() < 3 and abs(ship.angular_velocity) < 2:
		pod.set_light(true, player_vars.people_in_pod > 0, true)
		transfer_timer -= delta
		if transfer_timer <= 0:
			transfer_timer = 0.5 
			if player_vars.people_in_pod > 0:
				var person = load("res://ship/person.tscn").instantiate()
				player_vars.people_in_pod -= 1
				person.global_position = pod.global_position
				people_transferring.append(person)
				add_child(person)
	else:
		pod.set_light(false, player_vars.people_in_pod > 0, true)
		
	
			
func on_leave_area_body_entered(body):	
	if player_vars.people_on_ship > 0:
		player_vars.level_won = true
	else:
		player_vars.level_lost = true
	get_tree().change_scene_to_file("res://menu/menu.tscn")	

func handle_people_transfer(delta):
	for person in people_transferring:
		if not is_instance_valid(person):
			continue
		var pos = person.global_position
		var diff = ship.global_position - pos
		var dir = diff.normalized()
		if diff.length() < 0.5:
			person.queue_free()
			player_vars.people_on_ship += 1
			pickup_sound.play()
		else:
			pos += dir * delta * 50
			person.global_position = pos
			

func die():
	if dead:
		return
	Engine.time_scale = 0.01
	dead = true
	ship.freeze = true
	ship.hit_wall.disconnect(on_ship_hit_wall)
