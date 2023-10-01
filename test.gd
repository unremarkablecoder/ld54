extends Polygon2D

var vel = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate(delta)
	translate(vel * delta)

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		vel.x = 100
	else:
		vel.x = 0
