extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var cameraspeed = 350 # pixels / second

# Called when the node enters the scene tree for the first time.
func _ready():
	globals.on_planet = false
	globals.on_rocket = true
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Camera.position.x += cameraspeed * delta
	pass
