extends StaticBody2D

@export var light: Sprite2D
var light_timer = 0
var blink = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not blink:
		return
	light_timer += delta
	if light_timer > 0.5:
		light.visible = not light.visible
		light_timer = 0
	

func set_light(aligned, people_left, in_area):
	if not people_left:
		light.visible = false
		blink = false
		return
	
	
	if aligned:
		light.visible = true
		blink = false
		light.modulate = Color(0.2, 1, 0.2, 1)
	elif in_area:
		light.modulate = Color(0.2, 1, 0.2, 1)
		blink = true
	else:
		blink = true
		light.modulate = Color(1.0, 0.6, 0.1, 1)
	
