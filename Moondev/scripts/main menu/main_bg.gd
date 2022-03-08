extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var x_ratio := 16
var y_ratio := 9
var speed := 10


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	self.position+=(Vector2.DOWN * y_ratio + Vector2.RIGHT * x_ratio ) * speed * delta
	if self.position.x>=1280 || self.position.y>=720:
		self.position=Vector2.ZERO
	pass
