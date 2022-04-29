extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	globals.on_rocket = true
	pass 


# warning-ignore:unused_argument
func _physics_process(delta):
	$Camera.position.x += 0.5
	pass
