extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var x_ratio := 16
var y_ratio := 9
var speed := 20

var bg_texture1 = preload("res://scenes/png_res/back1.png")
var bg_texture2 = preload("res://scenes/png_res/back2.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_textures() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	$main_bg_left_up.texture = bg_texture1 if rng.randi_range(0,1) else bg_texture2
	rng.randomize()
	$main_bg_right_up.texture = bg_texture1 if rng.randi_range(0,1) else bg_texture2
	rng.randomize()
	$main_bg_left_down.texture = bg_texture1 if rng.randi_range(0,1) else bg_texture2
	rng.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position+=(Vector2.DOWN * y_ratio + Vector2.RIGHT * x_ratio ) * speed * delta
	if self.position.x>=1280 || self.position.y>=720:
		$main_bg_right_down.texture=$main_bg_left_up.texture
		self.position=Vector2.ZERO
		set_textures()
	pass
