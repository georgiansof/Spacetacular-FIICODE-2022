extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var on_pause := false
var camera_starting_x := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Background.visible = false
	$CenterContainer.visible = false
	pass 

func show():
	$Background.visible = true
	$CenterContainer.visible = true

func hide():
	$Background.visible = false
	$CenterContainer.visible = false

func TryAgain() -> void:
	globals.allow_pause = false
	self.show()
	$CenterContainer/VBoxContainer/Respawn.grab_focus()
	owner.get_node("Camera/player/AnimationPlayer").play("on_rocket")
	globals.is_paused_by_other_means = true
	owner.get_tree().paused = true
	on_pause = true
	pass
	
func _on_tryagain_unpaused():
	self.hide()
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	globals.allow_pause = true
	owner.get_node("Camera/player").position.x = 151
	owner.get_node("Camera/player").position.y = 399
	owner.get_node("Camera/player").rotation = 0
	owner.get_node("Camera/player").speed = 0.5
	owner.get_node("Camera").position.x = camera_starting_x
	globals.is_paused_by_other_means = false
	owner.get_tree().paused = false
	on_pause = false
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !globals.on_planet:
		if !on_pause:
			owner.get_node("Camera").position.x += globals.camera_speed * delta
		if owner.get_node("Camera/player").position.x<-210:
			TryAgain()
	pass

func _on_Respawn_pressed():
	_on_tryagain_unpaused()
	pass
