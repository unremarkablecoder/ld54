extends Node2D

@export var bl: Node2D
@export var tr: Node2D
@export var br: Node2D
@export var tl: Node2D

var pieces = []
var vel = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pieces.append(tl)
	pieces.append(tr)
	pieces.append(br)
	pieces.append(bl)
	
	var speed = 1000
	vel.append(Vector2(-1, -1).normalized() * speed)
	vel.append(Vector2(1, -1).normalized() * speed)
	vel.append(Vector2(1, 1).normalized() * speed)
	vel.append(Vector2(-1, 1).normalized() * speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in 4: 
		pieces[i].position += vel[i] * delta
		pieces[i].rotation += 5 * delta
