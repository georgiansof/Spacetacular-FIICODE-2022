extends KinematicBody2D

onready var ANIM = $AnimationPlayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func Animate() -> void:
	if globals.on_rocket==false:
		if globals.player_facing == "left":
			globals.player_state = "Stand_Left"
		else:
			globals.player_state = "Stand_Right"
			
		var IsRightKeyPressed := Input.is_action_pressed("action_right")
		var IsLeftKeyPressed := Input.is_action_pressed("action_left")
		var IsUpKeyPressed := Input.is_action_pressed("action_up")
		
		if IsRightKeyPressed && IsLeftKeyPressed:
			return
		elif IsRightKeyPressed:
			globals.player_facing = "right"
			globals.player_state = "Walk_Right"
		elif IsLeftKeyPressed:
			globals.player_facing = "left"
			globals.player_state = "Walk_Left"
		elif IsUpKeyPressed:
			if globals.player_facing == "right":
				globals.player_state = "Walk_Right"
			elif globals.player_facing == "left":
				globals.player_state = "Walk_Left"

		if ANIM.get_current_animation() != globals.player_state || IsUpKeyPressed:
			ANIM.play(globals.player_state)
	pass

# warning-ignore:unused_argument
func _process(delta):
	Animate()
	pass
