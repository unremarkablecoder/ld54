extends Control

@export var win_menu: Control
@export var station_menu: Control
@export var lose_menu: Control
@export var selection_arrow: Control

@export var win_stats_text: Label
@export var win_continue_label: Control

@export var lose_retry: Control
@export var lose_main_menu: Control

var player_vars

@export var level_labels: Array[Control] = []
var selection = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	selection = 0
	win_menu.visible = false
	station_menu.visible = false
	lose_menu.visible = false
	
	player_vars = $"/root/PlayerVars"
	if player_vars.level_won:
		win_menu.visible = true
		win_stats_text.text = "Level %d\nYou rescued %d people (%d died)\nYou finished in %.2f seconds." %\
		 [player_vars.current_level + 1, player_vars.people_on_ship, player_vars.people_dead, player_vars.level_timer]
	elif player_vars.level_lost:
		lose_menu.visible = true
	else:
		station_menu.visible = true
		selection = player_vars.current_level


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var offset = Vector2(-50, -15)
	if station_menu.visible:
		selection_arrow.position = level_labels[selection].position + offset
	elif win_menu.visible:
		selection_arrow.position = win_continue_label.position + offset
	elif lose_menu.visible:
		if selection == 0:
			selection_arrow.position = lose_retry.position + offset
		else:
			selection_arrow.position = lose_main_menu.position + offset
		
	

func _input(event):
	if win_menu.visible:
		if event.is_action_pressed("ui_accept"):
			win_menu.visible = false
			station_menu.visible = true
			selection = min(player_vars.current_level + 1, level_labels.size()-1)
	elif station_menu.visible:
		if event.is_action_pressed("ui_accept"):
			player_vars.current_level = selection
			get_tree().change_scene_to_file("res://game.tscn")
		if event.is_action_pressed("ui_down") and selection < level_labels.size()-1:
			selection += 1
		elif event.is_action_pressed("ui_up") and selection > 0:
			selection -= 1
	elif lose_menu.visible:
		if event.is_action_pressed("ui_accept"):
			if selection == 0:
				get_tree().change_scene_to_file("res://game.tscn")
			else:
				lose_menu.visible = false
				station_menu.visible = true
				selection = player_vars.current_level
		if event.is_action_pressed("ui_down") and selection < 1:
			selection += 1
		elif event.is_action_pressed("ui_up") and selection > 0:
			selection -= 1

	
