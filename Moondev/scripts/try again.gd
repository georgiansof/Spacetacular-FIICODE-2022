extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Background.visible = false
	$CenterContainer.visible = false
	pass 

func show():
	$Background.visible = true
	$CenterContainer.visible = true

func hide():
	$Background.visible = false
	$CenterContainer.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

signal unpaused

func _on_Respawn_pressed():
	self.emit_signal("unpaused")
	pass
