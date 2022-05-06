extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (int) var hit_count := 99999

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	print(self.mode)
	pass

func set_state_static() -> void:
	self.mode = RigidBody2D.MODE_STATIC
	
func set_state_rigid() -> void:
	self.mode = RigidBody2D.MODE_RIGID

func _on_pushable_rock_body_entered(body):
	pass # Replace with function body.


func _on_pushable_rock_body_exited(body):
	pass # Replace with function body.
