extends Node



onready var file_name := 'res://options.dat'
onready var savefile_name := 'res://savegame.dat'
var file := File.new()
var music_volume := 0
var sfx_volume := 0
var music_toggle := true
var sfx_toggle := true

# Called when the node enters the scene tree for the first time.
func _ready():
	if file.file_exists(file_name):
		file.open(file_name, File.READ)
		var input = file.get_as_text()
		if input != "":
			var settings = input.split(",")
			music_volume = int(settings[0])
			sfx_volume = int(settings[1])
			music_toggle = bool(int(settings[2]))
			sfx_toggle = bool(int(settings[3]))
		file.close()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
