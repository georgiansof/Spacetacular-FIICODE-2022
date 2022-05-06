extends Node2D

var checkpoint9k_passed := false

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
