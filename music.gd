extends AudioStreamPlayer


var player_vars

# Called when the node enters the scene tree for the first time.
func _ready():
	player_vars = $"/root/PlayerVars"
	stream_paused = not player_vars.music_on


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("toggle_music"):
		stream_paused = not stream_paused
		player_vars.music_on = not stream_paused

	
