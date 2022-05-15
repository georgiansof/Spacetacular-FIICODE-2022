extends RigidBody2D

export (int) var speed = 750
var left

func _ready():
	left = globals.player_facing == "left"
	self.linear_damp = 0
	pass 


#func _physics_process(delta):
	#position += -1 * transform.x * speed * delta if left else transform.x * speed * delta

func fire() -> void:
	var direction = Vector2.LEFT if left else Vector2.RIGHT
	apply_central_impulse(speed * direction)

#func rocket_fire(from) -> void:
#	var direction = (self.position - from.position).normalized()
#	apply_central_impulse(speed * direction) 

func _on_Bullet_body_entered(body):
	if body.is_in_group("destroyable"):
		if body.get("hit_count")==null:
			body.queue_free()
		else:
			if body.hit_count == 0:
				body.queue_free()
			else:
				body.hit_count -=1 
	if !body.is_in_group("deflectible"):
		queue_free()
	else: # TODO MIRROR DEFLECTION
		self.apply_central_impulse(Vector2.UP * 3 * speed)


	
#func _process(delta):
#	pass
