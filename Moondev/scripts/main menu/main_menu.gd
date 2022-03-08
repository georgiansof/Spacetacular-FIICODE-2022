extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func savegame_exists():
	if globals.file.file_exists(globals.savefile_name):
		return true
	return false

func UpdateFile():
	var strng = str(globals.music_volume) + "," + str(globals.sfx_volume) + "," + str(int(globals.music_toggle)) + "," + str(int(globals.sfx_toggle))
	globals.file.open(globals.file_name, File.WRITE)
	globals.file.store_string(strng)
	globals.file.close()
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("VBoxContainer/Continue").visible=false
	if savegame_exists(): # daca exista savegame
		get_node("VBoxContainer/Continue").visible=true
	get_node("MusicSlider").value = globals.music_volume
	get_node("SfxSlider").value = globals.sfx_volume
	get_node("MusicSlider/isMusicOn").pressed = globals.music_toggle
	get_node("SfxSlider/isSfxOn").pressed = globals.sfx_toggle
	$"VBoxContainer/New Game".grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Options_pressed():
	get_node("VBoxContainer").visible=false
	get_node("MusicSlider").visible=true
	get_node("SfxSlider").visible=true
	get_node("options_back").visible=true
	pass


func _on_options_back_pressed():
	get_node("VBoxContainer").visible=true
	get_node("MusicSlider").visible=false
	get_node("SfxSlider").visible=false
	get_node("options_back").visible=false
	pass 


func _on_MusicSlider_value_changed(value):
	var stream = get_node("Music")
	stream.volume_db = - (value/100.0*50) # percent to decibels
	globals.music_volume = value
	UpdateFile()
	pass 


	pass # Replace with function body.


func _on_isMusicOn_toggled(button_pressed):
	var stream = get_node("Music")
	if get_node("MusicSlider/isMusicOn").is_pressed():
		stream.volume_db = - (get_node("MusicSlider").value/100.0*50)
		globals.music_toggle = true
		UpdateFile()
	else: 
		stream.volume_db = -80
		globals.music_toggle = false
		UpdateFile()
	pass # Replace with function body.


func _on_isSfxOn_toggled(button_pressed):
	if get_node("SfxSlider/isSfxOn").is_pressed():
		globals.sfx_toggle = true
		UpdateFile()
	else: 
		globals.sfx_toggle = false
		UpdateFile()
	pass # Replace with function body.


func _on_SfxSlider_value_changed(value):
	globals.sfx_volume = value
	UpdateFile()
	pass # Replace with function body.
