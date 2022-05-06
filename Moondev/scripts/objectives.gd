extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var tw = $Animator
signal anim_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	$"Mission name".text = ""
	$"Mission description".text = ""
	pass 

func objective_complete() -> void:
	tw.interpolate_property($complete_bg, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tw.start()
	yield(tw,"tween_completed")
	tw.interpolate_property($complete_bg, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tw.start()
	emit_signal("anim_complete")
	
func new_objective(objective_name:String, objective_description:String) -> void:
	if tw.is_active():
		yield(self,"anim_complete")
	tw.interpolate_property($new_bg, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tw.start()
	yield(tw,"tween_completed")
	$"Mission name".text = objective_name
	$"Mission description".text = objective_description
	tw.interpolate_property($new_bg, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tw.start()
	pass

func change_objective_without_anim(objective_name:String, objective_description:String) -> void:
#	if tw.is_active():
#		yield(self,"anim_complete")
	$"Mission name".text = objective_name
	$"Mission description".text = objective_description
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
