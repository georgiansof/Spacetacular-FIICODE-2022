extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	pass

func hide() -> void:
	$Background.visible = false
	$CenterContainer.visible = false
	
func show() -> void:
	$Background.visible = true
	$CenterContainer.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

signal continue_pressed

func _on_Continue_pressed():
	self.emit_signal("continue_pressed")
	pass
