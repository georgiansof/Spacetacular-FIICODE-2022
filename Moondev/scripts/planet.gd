extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var interactible := false

# Called when the node enters the scene tree for the first time.
func _ready():
	globals.on_rocket=false
	globals.on_planet=true
	$Objectives.new_objective("On a lone planet","Learn to make use of your abilities")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	if $Player.position.x > 900 && Input.is_action_just_pressed("action_restart"):
		$Player.position.x = 900
		$Player.position.y = 470
	if interactible && Input.is_action_just_pressed("action_interact"):
		globals.is_paused_by_other_means = true
		get_tree().paused = true
		$tutorial_complete.show()
	pass

# warning-ignore:unused_argument
func _on_EndTutorialArea_body_entered(body):
	if body.get_collision_layer()==2:
		interactible = true
	pass 


func _on_tutorial_complete_continue_pressed():
	get_tree().paused = false
	globals.is_paused_by_other_means = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/world.tscn")
	var settings = {"NG": false, "Tutorial": false}
	globals.Save(settings)
	pass 


func _on_EndTutorialArea_body_exited(body):
	if body.get_collision_layer()==2:
		interactible = false
	pass # Replace with function body.
