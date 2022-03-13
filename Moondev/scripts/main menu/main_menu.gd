extends Control

var svgInputTxt:="null"
var popup_choice:=false

func savegame_exists() -> bool:
	var files = globals.list_files_in_directory(globals.savefile_dir,"dat")
	return true if files.size()>0 else false

func UpdateFile() -> void:
	var strng = str(globals.music_volume) + "," + str(globals.sfx_volume) + "," + str(int(globals.music_toggle)) + "," + str(int(globals.sfx_toggle))
# warning-ignore:return_value_discarded
	globals.file.open(globals.options_file, File.WRITE)
	globals.file.store_string(strng)
	globals.file.close()
	pass

func _ready():
	get_node("VBoxContainer/Continue").visible=false
	if savegame_exists(): # daca exista savegame
		get_node("VBoxContainer/Continue").visible=true
	get_node("MusicSlider").value = globals.music_volume
	get_node("SfxSlider").value = globals.sfx_volume
	get_node("MusicSlider/isMusicOn").pressed = globals.music_toggle
	get_node("SfxSlider/isSfxOn").pressed = globals.sfx_toggle
	$"VBoxContainer/New Game".grab_focus()
	pass 

func Hide_UI() -> void:
	$NG_menu.visible = true
	$VBoxContainer.visible = false
	pass

func CheckFileExists(name:String) -> bool:
	var files:PoolStringArray = globals.list_files_in_directory(globals.savefile_dir,"dat")
	for x in files:
		if x==name:
			return true
	return false

func _on_SavegameInput_text_entered(new_text):
	svgInputTxt=new_text
	if svgInputTxt=="":
		svgInputTxt="null"
	pass 

func _on_Create_pressed():
	$NG_menu/SavegameInput.emit_signal("text_entered",$NG_menu/SavegameInput.text)
	pass 
	
func _on_SvgPopUp_confirmed():
	popup_choice = true
	$SvgPopUp.hide()
	pass 
	
func CheckNumberOfSaves() -> int:
	var files = globals.list_files_in_directory(globals.savefile_dir,"dat")
	return files.size()

func _on_New_Game_pressed():
	Hide_UI()
	if CheckNumberOfSaves()>=10:
		$NG_menu.visible=false
		$SvgErrPopUp.popup()
		yield($SvgErrPopUp,"popup_hide")
		$VBoxContainer.visible = true
		return
	$NG_menu/SavegameInput.text=""
	yield($NG_menu/SavegameInput,"text_entered")
	var name:String = svgInputTxt
	svgInputTxt="null" 
	var file_exists:bool = CheckFileExists(name+".dat")
	popup_choice = false
	if file_exists:
		# ask overwrite
		$NG_menu.visible=false
		$SvgPopUp.dialog_text="Savegame "+name+" already exists. Overwrite?"
		$SvgPopUp.popup() # FIXME cancel button not working
		yield($SvgPopUp,"popup_hide")
		#
	if !file_exists || popup_choice==true:
			var file=File.new()
			file.open(globals.savefile_dir+name+".dat",File.WRITE)
			file.store_string("")
			file.close()
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://scenes/NG.tscn") # exit the main menu and start NG
	elif file_exists && popup_choice==false:
		yield(_on_New_Game_pressed(),"completed")
	pass

func _on_Options_pressed():
	get_node("VBoxContainer").visible=false
	get_node("MusicSlider").visible=true
	get_node("SfxSlider").visible=true
	get_node("options_back").visible=true
	pass

func _on_Quit_pressed():
	get_tree().quit()
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
	if globals.music_volume != value:
		globals.music_volume = value
		globals.music_toggle = true
		$MusicSlider/isMusicOn.pressed = true
		UpdateFile()
	pass 


	pass # Replace with function body.


# warning-ignore:unused_argument
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


# warning-ignore:unused_argument
func _on_isSfxOn_toggled(button_pressed):
	if get_node("SfxSlider/isSfxOn").is_pressed():
		globals.sfx_toggle = true
		UpdateFile()
	else: 
		globals.sfx_toggle = false
		UpdateFile()
	pass # Replace with function body.


func _on_SfxSlider_value_changed(value):
	if value!=globals.sfx_volume:
		globals.sfx_volume = value
		globals.sfx_toggle = true
		$SfxSlider/isSfxOn.pressed=true
		UpdateFile()
	pass # Replace with function body.


func _on_Back_NG_pressed():
	$NG_menu.visible = false
	$VBoxContainer.visible = true
	pass 

func isalphanum(c) -> bool:
	return c>='0' && c<='9' || c>='a' && c<='z' || c>='A' && c<='Z'

func _on_SavegameInput_text_changed(new_text):
	if new_text.length()>0 && !isalphanum(new_text[new_text.length()-1]):
		new_text.erase(new_text.length()-1,1)
		$NG_menu/SavegameInput.text=new_text
		$NG_menu/SavegameInput.caret_position=new_text.length()
	pass

