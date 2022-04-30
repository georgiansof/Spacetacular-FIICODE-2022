extends Area2D

var speed = 750
var left

func _ready():
	left = globals.player_facing == "left"
	pass 
	
func _physics_process(delta):
	position += -1 * transform.x * speed * delta if left else transform.x * speed * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("destroyable"):
		body.queue_free()
	queue_free()

#func _process(delta):
#	pass
