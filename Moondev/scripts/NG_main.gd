extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	$VideoPlayer.volume_db = linear2db(globals.music_volume/100.0)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VideoPlayer_finished():
	var settings:= {"NG" : false}
	globals.Save(globals.current_savegame,settings)
	pass 
