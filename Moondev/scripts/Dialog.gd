extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var f_key = preload("res://scenes/png_res/Fkey.png")
var f_key_inverted = preload("res://scenes/png_res/Fkey_inverted.png")
onready var sprite = $Background/Sprite
onready var label = $Background/RichTextLabel
signal text_read
signal all_read

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

func _input(event):
	if event.is_action_pressed("action_skip"):
		sprite.texture = f_key_inverted
	elif event.is_action_released("action_skip"):
		self.emit_signal("text_read")
		sprite.texture = f_key

func show(replies):
	get_tree().paused = true
	globals.is_paused_by_other_means = true
	$Background.visible = true
	for r in replies:
		label.text = r
		yield(self,"text_read")
	$Background.visible = false
	globals.is_paused_by_other_means = false
	get_tree().paused = false
	self.emit_signal("all_read")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
