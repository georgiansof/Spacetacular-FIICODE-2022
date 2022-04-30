extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var tween = $Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	globals.on_planet = false
	globals.on_rocket = true
	pass 

# warning-ignore:unused_argument
func _process(delta):
	if !globals.on_planet:
		$Camera.position.x += 150*delta
	pass
	
func TryAgain() -> void:
	$tryagain.show()
	$Camera/player/AnimationPlayer.play("on_rocket")
	globals.is_paused_by_other_means = true
	get_tree().paused = true
	pass
	
func _physics_process(delta):
	if $Camera/player.position.x<-210:
		TryAgain()
	pass


func _on_tryagain_unpaused():
	$tryagain.hide()
	$Camera/player.position.x = 151
	$Camera/player.position.y = 399
	$Camera/player.rotation = 0
	$Camera/player.speed = 0.5
	$Camera.position.x = 0
	globals.is_paused_by_other_means = false
	get_tree().paused = false
	pass 

func fade_out() -> void:
	$Camera/player.visible = false
	tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	pass

func _on_field_body_entered(_body):
	fade_out()
# warning-ignore:return_value_discarded
	var timer = get_tree().create_timer(2.0)
	yield(timer,"timeout")
	var settings = {"NG":false, "Tutorial":true}
	globals.Save(globals.current_savegame,settings)
	get_tree().change_scene("res://scenes/planet.tscn")
	pass 
