extends CanvasLayer

@export var people_text: Label
@export var hull_text: Label
@export var pause_text: Label
var player_vars

# Called when the node enters the scene tree for the first time.
func _ready():
	player_vars = $"/root/PlayerVars"
	pause_text.visible = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	people_text.text = "Rescued: %d, Pod: %d, Dead: %d" % [player_vars.people_on_ship, player_vars.people_in_pod, player_vars.people_dead]
	hull_text.text = "Hull Integrity: %d" % player_vars.hull_integrity


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if pause_text.visible:
			get_tree().paused = false
			get_tree().change_scene_to_file("res://menu/menu.tscn")
		else:
			pause_text.visible = true
			get_tree().paused = true
	if event.is_action_pressed("ui_accept") and pause_text.visible:
		get_tree().paused = false
		pause_text.visible = false
		
