extends Node2D

var checkpoint9k_passed := false
onready var tween = $Tween
var purple_planet_shown := false

func _ready():
	var save_settings = globals.Load()
	if save_settings.has("checkpoint"):
		if save_settings["checkpoint"]=="9K":
			checkpoint9k_passed = true
			$tryagain.camera_starting_x = 8849
			$Camera.position.x = 8849
	globals.on_planet = false
	globals.on_rocket = true
	$Objectives.new_objective("On my way to nowhere","Survive the meteor storm")
	pass 

func CP9K_Save() -> void:
	var settings = globals.Load()
	settings["checkpoint"]="9K"
	globals.Save(settings)
	pass

func _process(_delta):
	if checkpoint9k_passed == false:
		if $Camera/player.global_position.x > 9000:
			checkpoint9k_passed = true
			CP9K_Save()
	if !purple_planet_shown && $Camera/player.global_position.x >= 15500:
		$Objectives.new_objective("One interesting looking one", "Visit the purple planet")
		purple_planet_shown=true

func fade_out() -> void:
	$Camera/player.visible = false
	tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	pass

func _on_field_body_entered(body):
	if body.get_collision_layer()==2:
		fade_out()
	# warning-ignore:return_value_discarded
		var timer = get_tree().create_timer(2.0)
		yield(timer,"timeout")
		var settings = globals.Load()
		settings["checkpoint"] = "purple_planet"
		globals.Save(settings)
		get_tree().change_scene("res://scenes/purple_planet.tscn")
	pass 
