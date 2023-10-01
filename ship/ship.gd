extends RigidBody2D

signal hit_wall(force)

@export var thruster_main: GPUParticles2D
@export var thruster_reverse: GPUParticles2D
@export var thruster_right: GPUParticles2D
@export var thruster_left: GPUParticles2D
@export var thruster_main_sound: AudioStreamPlayer
@export var thruster_secondary_sound: AudioStreamPlayer

var thrust = Vector2(0, -100)
var thrust_back = Vector2(0, 50)
var torque = 1000

var in_docking_area = false
var input_fwd = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		

func _integrate_forces(state):
	if Input.is_action_pressed("ui_up"):
		state.apply_force(thrust.rotated(rotation))
		thruster_main.emitting = true
		if not thruster_main_sound.playing:
			thruster_main_sound.play()
		thruster_main_sound.stream_paused = false
	else:
		state.apply_force(Vector2())
		thruster_main.emitting = false
		thruster_main_sound.stream_paused = true
		
	var secondary = false		
	if Input.is_action_pressed("ui_down"):
		state.apply_force(thrust_back.rotated(rotation))
		thruster_reverse.emitting = true
		secondary = true
	else:
		thruster_reverse.emitting = false
		
	var rotation_dir = 0
	if (Input.is_action_pressed("ui_right")):
		rotation_dir += 1
		thruster_right.emitting = true
		secondary = true
	else:
		thruster_right.emitting = false
	if (Input.is_action_pressed("ui_left")):
		rotation_dir -= 1	
		thruster_left.emitting = true
		secondary = true
	else:
		thruster_left.emitting = false
		
	if secondary:
		if not thruster_secondary_sound.playing:
			thruster_secondary_sound.play()
	thruster_secondary_sound.stream_paused = not secondary
			
	state.apply_torque(rotation_dir * torque)


func _on_body_entered(body):
	hit_wall.emit(linear_velocity.length())
	print(body)
