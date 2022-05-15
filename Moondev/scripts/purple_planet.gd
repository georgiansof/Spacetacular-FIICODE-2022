extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal alien_choice
onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$instr.visible = false
	$Mirror/CollisionPolygon2D.disabled = true
	$Mirror/CollisionShape2D.disabled = true
	$Mirror.visible = false
	$PATH.text = ""
	$house_light.modulate = Color(0,0,0,1)
	globals.on_planet = true
	globals.on_rocket = false
	$Objectives.new_objective("On ultra_violet ground","Search for evidence of Larisse's passing")
	pass # Replace with function body.

func _choice() -> void:
	yield($Choice.show("I don't want to help you live, you grumpy thing","I'll see what I can do","What do I earn from this?",0,0,0,true,10),"completed")
	emit_signal("alien_choice")
	pass


func _on_alien_decided():
	anim.play(globals.option+"_path")
	yield(anim,"animation_finished")
	$instr.visible = true
	$Mirror/CollisionPolygon2D.disabled = false
	$Mirror/CollisionShape2D.disabled = false
	$Mirror.visible = true
	pass 
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Windows_body_entered(_body):
	anim.play("alien_appear")
	$"background sprites/Windows/CollisionShape2D".set_deferred("disabled", true)
	$"background sprites/Windows/CollisionShape2D2".set_deferred("disabled", true)
	pass 
	

onready var tween = $Tween

func _on_Area2D_body_entered(_body):
	var root=self
	tween.interpolate_property(root, "modulate", root.modulate, Color(0,0,0,0), 3, 1 , Tween.EASE_IN, 0)
	tween.start()
	root.get_node("Objectives/ColorRect").visible=false
	root.get_node("Objectives/Mission name").visible=false
	root.get_node("Objectives/Mission description").visible=false
	root.get_node("Objectives/complete_bg").visible=false
	root.get_node("Objectives/new_bg").visible=false
	yield(tween,"tween_all_completed")

# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/alphatest.tscn")
	pass 
