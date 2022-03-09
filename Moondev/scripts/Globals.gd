extends Node



onready var options_file := "user://options.dat"
onready var savefile_dir := "user://savegames/"

var file := File.new()
var music_volume := 0
var sfx_volume := 0
var music_toggle := true
var sfx_toggle := true

func Init_Directories() -> void:
	var dir = Directory.new()
	dir.open("user://")
	if not dir.dir_exists(savefile_dir):
		dir.make_dir("savegames")

func Init_Options() -> void:
	if file.file_exists(options_file):
# warning-ignore:return_value_discarded
		file.open(options_file, File.READ)
		var input = file.get_as_text()
		if input != "":
			var settings = input.split(",")
			music_volume = int(settings[0])
			sfx_volume = int(settings[1])
			music_toggle = bool(int(settings[2]))
			sfx_toggle = bool(int(settings[3]))
		file.close()
	else: 
# warning-ignore:return_value_discarded
		file.open(options_file, File.WRITE)
		var default_settings = "0,0,1,1"
		file.store_string(default_settings)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	Init_Directories()
	Init_Options()
	pass

func list_files_in_directory(path,ext):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
# warning-ignore:shadowed_variable
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.get_extension() == ext:
			files.append(file)

	dir.list_dir_end()

	return files

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
