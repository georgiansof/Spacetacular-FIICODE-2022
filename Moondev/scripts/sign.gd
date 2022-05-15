extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var interact := false
onready var diag
export (Array,String) var repl


# Called when the node enters the scene tree for the first time.
func _ready():
	var own = get_parent()
	while !own.has_node("Dialog"):
		own = own.get_parent()
	diag = own.get_node("Dialog")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if interact && Input.is_action_just_pressed("action_interact"):
		diag.show(repl)

func _on_Sign_body_entered(body):
	if body.get_collision_layer()==2:
		interact = true
	pass # Replace with function body.


func _on_Sign_body_exited(body):
	if body.get_collision_layer()==2:
		interact = false
	pass # Replace with function body.
