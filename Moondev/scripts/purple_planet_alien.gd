extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var animplayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func anim_change(new_anim:String):
	animplayer.play(new_anim)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
