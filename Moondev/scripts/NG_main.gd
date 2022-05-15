extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var backstory = preload("res://scenes/vid_res/backstory.webm")
var backstory_loaded := false
onready var tween = $Tween
onready var skiplabel = $Skip

func _ready():
	$VideoPlayer.volume_db = linear2db(globals.music_volume/100.0)
	var savefile = File.new()
	savefile.open(globals.savefile_dir+globals.current_savegame, File.READ)
	var text = savefile.get_as_text()
	savefile.close()
	tween.interpolate_property(skiplabel, "modulate", Color(1,1,1,0), Color(1,1,1,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	tween.interpolate_property(skiplabel, "modulate", Color(1,1,1,1), Color(1,1,1,0), 7.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	if text!="":
		_on_VideoPlayer_finished()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("action_skip"):
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
		globals.Save(settings)
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/overworld.tscn")
	else:
		var settings:= {"NG" : true}
		globals.Save(settings)
		Load_Backstory()
	pass 
