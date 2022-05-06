extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var tween = $Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	globals.on_planet = false
	globals.on_rocket = true
	$Objectives.new_objective("Welcome","I am your objective tracker!\nFollow the instructions to maneuver the rocket")
	pass 

# warning-ignore:unused_argument
func _process(delta):
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
	globals.Save(settings)
	get_tree().change_scene("res://scenes/planet.tscn")
	pass 
