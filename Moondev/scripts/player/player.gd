extends KinematicBody2D

onready var ANIM = $AnimationPlayer

var pause := false
var rocket_states = ["on_rocket","rocket_boosting_loop","rocket_start_boosting"]
# viteze
var speed:=0.5
var rotation_speed:=2

var acceleration:=0.05
var fastacceleration:= 0.2
var maxspeed:=5

var brakespeed:=0.1
var fastbrakespeed:=0.8
var passivebrake:=0.01
#

func _ready():
	$AudioStreamPlayer.volume_db = linear2db (globals.sfx_volume/100.0 * 0.5)
	pass 

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
	else:
		globals.player_state = "on_rocket"
		globals.player_facing = "right"
		var IsSpaceJustPressed := Input.is_action_just_pressed("action_boost")
		var IsSpacePressed := Input.is_action_pressed("action_boost")
		var IsSpaceJustReleased := Input.is_action_just_released("action_boost")
		if IsSpaceJustPressed:
			ANIM.play("rocket_start_boosting")
			pause = true
			yield(ANIM,"animation_finished")
			pause = false
		if IsSpacePressed && !pause: 
			ANIM.play("rocket_boosting_loop")
		else:
			if !pause:
				ANIM.play("on_rocket")
		if IsSpaceJustReleased:
			ANIM.play("on_rocket")
	pass

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("rocket"):
		globals.on_rocket = !globals.on_rocket
	Animate()
	pass
	

# warning-ignore:shadowed_variable
func move(speed):
	var angle:float
	angle = self.rotation
	#angle = angle*PI/180
	self.position.x+=speed*cos(angle)
	self.position.y+=sin(angle)*speed

func find(x: String, a) -> bool:
	for y in a:
		if x==y:
			return true
	return false

# warning-ignore:unused_argument
func _physics_process(delta):
	if find(globals.player_state, rocket_states):
		if Input.is_action_pressed("action_left"): 
			self.rotation_degrees-=rotation_speed
			move(speed)
		if Input.is_action_pressed("action_right"):
			self.rotation_degrees+=rotation_speed
			move(speed)
		if Input.is_action_pressed("action_boost"):
			if speed > 0 && speed < 0.4:
				speed += fastacceleration
			if speed+acceleration < maxspeed:
				speed += acceleration
			else:
				speed=maxspeed
		if Input.is_action_pressed("action_brake"):
			if speed > 0:
				speed-=brakespeed
		if Input.is_action_pressed("action_fastbrake"):
			speed-=fastbrakespeed
			if (speed<0): speed=0
		move(speed)
		if speed - passivebrake > 0.5:
			speed-=passivebrake
		else:
			speed = 0.5
	pass
