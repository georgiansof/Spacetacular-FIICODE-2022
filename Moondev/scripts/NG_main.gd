extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var backstory = preload("res://scenes/vid_res/backstory.webm")
var backstory_loaded := false

func _ready():
	$VideoPlayer.volume_db = linear2db(globals.music_volume/100.0)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("action_skip") && backstory_loaded==false:
		$VideoPlayer.stop()
		$VideoPlayer.emit_signal("finished")
	pass

func Load_Backstory() -> void:
	$VideoPlayer.stream = backstory
	$VideoPlayer.play()
	backstory_loaded = true
	

func _on_VideoPlayer_finished():
	if backstory_loaded==true:
		var settings:= {"NG" : false}
		globals.Save(globals.current_savegame,settings)
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/overworld.tscn")
	else:
		Load_Backstory()
	pass 
