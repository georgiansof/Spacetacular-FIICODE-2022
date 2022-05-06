extends KinematicBody2D

onready var ANIM = $AnimationPlayer
export (PackedScene) var Bullet0
export (PackedScene) var Bullet1
export (PackedScene) var Bullet2

var pause := false
var rocket_states = ["on_rocket","rocket_boosting_loop","rocket_start_boosting"]
# viteze
var speed=0.5
export (int) var mass = 1
export (int) var rotation_speed=3

export (int) var acceleration=25
export (int) var fastacceleration= 50
export (int) var maxspeed=300
export (int) var maxspeed_y=200

export (int) var brakespeed=25
export (int) var fastbrakespeed=50
export (int) var passivebrake=10

export (int) var run_speed = 100
export (int) var jump_speed = -400
export (int) var gravity = 1200
var velocity = Vector2()
var jumping = false
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
		var IsSpacePressed := Input.is_action_pressed("action_shoot")
		var IsSpaceJustPressed := Input.is_action_just_pressed("action_shoot")
		
		if IsRightKeyPressed && IsLeftKeyPressed:
			return
		elif IsRightKeyPressed:
			globals.player_facing = "right"
			globals.player_state = "Walk_Right"
		elif IsLeftKeyPressed:
			globals.player_facing = "left"
			globals.player_state = "Walk_Left"
		elif !is_on_floor():
			if globals.player_facing == "right":
				globals.player_state = "Fall_Right"
			elif globals.player_facing == "left":
				globals.player_state = "Fall_Left"
				
		if globals.player_facing == "right":
			if IsSpaceJustPressed:
				ANIM.play("Start_Shooting_Right")
				pause = true
				yield(ANIM,"animation_finished")
				pause = false
			if IsSpacePressed && !pause:
				globals.player_state = "Shoot_Right"
		else:
			if IsSpaceJustPressed:
				ANIM.play("Start_Shooting_Left")
				pause = true
				yield(ANIM,"animation_finished")
				pause = false
			if IsSpacePressed && !pause:
				globals.player_state = "Shoot_Left"

		if !pause && (ANIM.get_current_animation() != globals.player_state || IsUpKeyPressed):
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
	Animate()
	pass
	

# warning-ignore:shadowed_variable
func move(speed):
	var angle:float
	angle = self.rotation
	#angle = angle*PI/180
	if (sin(angle)*speed>maxspeed_y):
		speed=maxspeed_y
	#self.position.x+=speed*cos(angle)
	#self.position.y+=sin(angle)*speed
	
# warning-ignore:return_value_discarded
	self.move_and_slide(speed*(Vector2(cos(angle),sin(angle)).normalized()),Vector2(0,0),false,4,0.785398,false)

func find(x: String, a) -> bool:
	for y in a:
		if x==y:
			return true
	return false

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('action_right')
	var left = Input.is_action_pressed('action_left')
	var jump = Input.is_action_just_pressed("action_up")

	if jump and is_on_floor():
		jumping = true
		velocity.y = jump_speed
	if right:
		velocity.x += run_speed
	if left:
		velocity.x -= run_speed

func shoot() -> void:
#	var rng = RandomNumberGenerator.new()
#	rng.randomize()
#	var x = int(abs(rng.randi()))%3
	var b
#	if x%3==0:
#		b = Bullet0.instance()
#	elif x%3==1:
#		b = Bullet1.instance()
#	elif x%3==2:
	b = Bullet2.instance()
	owner.add_child(b)
	b.transform = $Muzzle.global_transform
	b.fire()
	
func rocket_shoot() -> void:
#	var rng = RandomNumberGenerator.new()
#	rng.randomize()
#	var x = int(abs(rng.randi()))%3
	var b
#	if x%3==0:
#		b = Bullet0.instance()
#	elif x%3==1:
#		b = Bullet1.instance()
#	elif x%3==2:
	b = Bullet0.instance()
	owner.add_child(b)
	b.transform = $RocketMuzzle.global_transform
	var direc = b.speed * Vector2(cos(self.rotation),sin(self.rotation)).normalized()
	b.apply_central_impulse(globals.camera_speed * Vector2.RIGHT) # RELATIV LA CAMERA
	b.apply_central_impulse(direc)
	#b.rocket_fire(self)

func rocketshoot_eligible() -> bool:
	var ineligible_scenes = ["NG", "overworld", "planet"]
	if find(get_tree().current_scene.name,ineligible_scenes) || (get_tree().current_scene.name == "world" && self.global_position.x < 9000):
		return false
	return true

# warning-ignore:unused_argument
func _physics_process(delta):
			
	if find(globals.player_state, rocket_states):
		if Input.is_action_pressed("action_left"): 
			self.rotation_degrees-=rotation_speed
		if Input.is_action_pressed("action_right"):
			self.rotation_degrees+=rotation_speed
		if Input.is_action_pressed("action_boost"):
			if speed > 0 && speed < 0.4:
				speed += fastacceleration
			if speed+acceleration < maxspeed:
				speed += acceleration
			else:
				speed=maxspeed
		if Input.is_action_pressed("action_brake"):
			if speed > -1:
				speed-=brakespeed
		if Input.is_action_pressed("action_fastbrake"):
			speed-=fastbrakespeed
			if (speed<-1): speed=-75
		move(speed)
		if speed - passivebrake > 0:
			speed-=passivebrake
		else:
			if (speed>0): speed = 0
		if rocketshoot_eligible() && Input.is_action_pressed("action_shoot"):
			$RocketShoot_animplayer.play("Shooting")
		else:
			$RocketShoot_animplayer.play("Idle")
	else: # not on rocket
		get_input()
		velocity.y += gravity * delta
		if jumping && is_on_floor():
			jumping = false
		velocity = move_and_slide(velocity, Vector2(0, -1))
	pass
