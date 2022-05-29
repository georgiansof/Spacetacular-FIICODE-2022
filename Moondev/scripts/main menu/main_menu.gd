extends Control
###
onready var SFXPlayer = $SFX

var svgInputTxt:="null"
var popup_choice:=false
var slot_node
var continue_popup_choice:=false
var rmv_popup_choice:=false
var main_menu_theme = preload("res://soundtrack/main_theme.wav")
var button_press_sfx = preload("res://sfx/button_advance.wav")
var button_back_sfx = preload("res://sfx/button_back.wav")
var attention_popup_sfx = preload("res://sfx/attention_popup.wav")
var dialogue_popup_sfx = preload("res://sfx/dialogue_popup.wav")
var impact_sfx = preload("res://sfx/low-impact.wav")
var quit_sfx = preload("res://sfx/quit.wav")
var o_button_press_sfx = preload("res://sfx/button_advance.wav")
var o_button_back_sfx = preload("res://sfx/button_back.wav")
var o_attention_popup_sfx = preload("res://sfx/attention_popup.wav")
var o_dialogue_popup_sfx = preload("res://sfx/dialogue_popup.wav")
var o_impact_sfx = preload("res://sfx/low-impact.wav")
var o_quit_sfx = preload("res://sfx/quit.wav")
var timer
var play_ng_sfx := true
onready var mod = $"Game Title".get_modulate()
onready var vboxmod = $VBoxContainer.get_modulate()
onready var main_mod = self.get_modulate()
var modspeed := 1.5
var vboxmodspeed := 2.5
var main_modspeed := 1
var buttons_disabled := false
var fading := false

onready var tween_out = $TweenOut
onready var tween = $Tween
onready var music_player = $Music
var modres = preload("res://scenes/mod.tscn")

export var transition_duration = 1.00
export var transition_type = 1

func InitKeys() -> void:
	var file = File.new()
	file.open("user://keybindings.json",File.READ)
	var dict = str2var(file.get_as_text())
	file.close()
	var actions = ["action_right","action_left","action_skip",\
		"pause","action_boost","action_brake","action_fastbrake", \
		"action_restart","action_shoot","action_interact","action_anger",\
		"action_empathy","action_pragmatism"]
	
	var default = {"action_up" : "W"}
	default["action_pragmatism"] = "J"
	default["action_empathy"] = "G"
	default["action_anger"] = "Y"
	default["action_interact"] = "E"
	default["action_shoot"] = "SPACE"
	default["action_restart"] = "R"
	default["action_fastbrake"] = "CONTROL"
	default["action_brake"] = "S"
	default["action_boost"] = "W"
	default["pause"] = "ESCAPE"
	default["action_skip"] = "F"
	default["action_left"] = "A"
	default["action_right"] = "D"
	
	for a in actions:
		if dict.has(a) && (OS.find_scancode_from_string(dict[a])):
			var ev = InputEventKey.new()
			ev.scancode = OS.find_scancode_from_string(default[a])
			InputMap.action_erase_event(a,ev)
			ev.scancode = OS.find_scancode_from_string(dict[a])
			InputMap.action_add_event(a, ev)

func _ready():
	music_player.stream = main_menu_theme
	music_player.play()
	var file= File.new()
	if !file.file_exists("user://keybindings.json"):
		CreateKeybindings("user://")
	else:
		file.open("user://keybindings.json",File.READ)
		if file.get_as_text()=="":
			CreateKeybindings("user://")
		else:
			InitKeys()
	#fade_in($Music)
	$"SfxSlider/Fade Enable/CheckButton".pressed = globals.fadecheck
	if globals.fadecheck == true:
		mod.a = 0
		vboxmod.a = 0
		buttons_disabled = true
		$"Game Title".set_modulate(mod)
		$VBoxContainer.set_modulate(vboxmod)
	timer = get_tree().create_timer(0.0)
	var children = self.get_children()
	for i in range (0,children.size()):
		if children[i].name!="Music" && children[i].name!="SFX" && children[i].name!="Tween" && children[i].name!="TweenOut": children[i].visible = false
	for i in range (0,4):
		children[i].visible = true
	
	var dir = Directory.new()
	if dir.dir_exists(OS.get_executable_path().get_base_dir()+"/mods"):
		$MODS.visible=true
		init_mods()
		
	if globals.default_savegame!="#":
		get_node("VBoxContainer/Continue").visible=true
	get_node("MusicSlider").value = globals.music_volume
	get_node("SfxSlider").value = globals.sfx_volume
	get_node("MusicSlider/isMusicOn").pressed = globals.music_toggle
	get_node("SfxSlider/isSfxOn").pressed = globals.sfx_toggle
	$"VBoxContainer/New Game".grab_focus()
	pass 

func _process(delta):
	if fading:
		if main_mod.a - 1.0/main_modspeed * delta > 0:
			main_mod.a -= 1.0/main_modspeed * delta
		else:
			main_mod.a = 0
	
	if mod.a + 1.0/modspeed * delta < 1 :
		mod.a += 1.0/modspeed * delta
	else:
		mod.a = 1
		
	if mod.a ==1:
		if vboxmod.a + 1.0/vboxmodspeed * delta < 1 :
			vboxmod.a += 1.0/vboxmodspeed * delta
		else:
			vboxmod.a = 1
			buttons_disabled = false
	$"Game Title".set_modulate(mod)
	$VBoxContainer.set_modulate(vboxmod)
	self.set_modulate(main_mod)
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
	if CheckFileExists($NG_menu/SavegameInput.text+".dat"):
		$SFX.stream = button_press_sfx
		timer = get_tree().create_timer(1.0)
		$SFX.play()
		$NG_menu/Create.disabled = true
		$NG_menu/Back.disabled = true
		yield(timer, "timeout")
	$NG_menu/SavegameInput.emit_signal("text_entered",$NG_menu/SavegameInput.text)
	$NG_menu/Create.disabled = false
	$NG_menu/Back.disabled = false
	pass 
	
func _on_SvgPopUp_confirmed():
	fade_out($Music)
	popup_choice = true
	$SvgPopUp.hide()
	pass 
	
func CheckNumberOfSaves() -> int:
	var files = globals.list_files_in_directory(globals.savefile_dir,"dat")
	return files.size()

func _on_New_Game_pressed():
	$MODS.visible = false
	if buttons_disabled:
		return
	if play_ng_sfx:
		$SFX.stream = button_press_sfx
		$SFX.play()
	play_ng_sfx = false
	Hide_UI()
	if CheckNumberOfSaves()>=10:
		$NG_menu.visible=false
		$SvgErrPopUp.popup()
		$SFX.stream = attention_popup_sfx
		$SFX.play()
		yield($SvgErrPopUp,"popup_hide")
		$VBoxContainer.visible = true
		$MODS.visible = true
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
		$SvgPopUp.popup()
		$SFX.stream = dialogue_popup_sfx
		$SFX.play()
		yield($SvgPopUp,"popup_hide")
			
		#
	if !file_exists || popup_choice==true:
			fading=true
			$SFX.stream=impact_sfx
			$SFX.play()
			fade_out($Music)
			timer = get_tree().create_timer(3.5)
			yield(timer, "timeout")
			var file=File.new()
			file.open(globals.savefile_dir+name+".dat",File.WRITE)
			file.store_string("")
			file.close()
			globals.default_savegame=name+".dat"
			globals.UpdateFile()
# warning-ignore:return_value_discarded
			globals.current_savegame=name+".dat"
			Load_Game(globals.current_savegame)

	elif file_exists && popup_choice==false:
		yield(_on_New_Game_pressed(),"completed")
	pass

func _on_Options_pressed():
	if buttons_disabled:
		return
	$SFX.stream=button_press_sfx
	$SFX.play()
	$MODS.visible=false
	get_node("VBoxContainer").visible=false
	get_node("MusicSlider").visible=true
	get_node("SfxSlider").visible=true
	get_node("options_back").visible=true
	pass

func _on_Quit_pressed():
	if buttons_disabled:
		return
	if timer.time_left <= 0.0:
		SFXPlayer.stream = quit_sfx
		SFXPlayer.play()
		timer = get_tree().create_timer(1.0)
		yield(timer, "timeout")
	get_tree().quit()
	pass

func _on_options_back_pressed():
	$SFX.stream=button_back_sfx
	$SFX.play()
	$MODS.visible = true
	get_node("VBoxContainer").visible=true
	get_node("MusicSlider").visible=false
	get_node("SfxSlider").visible=false
	get_node("options_back").visible=false
	pass 


func _on_MusicSlider_value_changed(value):
	var stream = get_node("Music")
	stream.volume_db = linear2db(value/100.0)
	if globals.music_volume != value:
		globals.music_volume = value
		globals.music_toggle = true
		$MusicSlider/isMusicOn.pressed = true
		globals.UpdateFile()
	pass 


	pass # Replace with function body.


# warning-ignore:unused_argument
func _on_isMusicOn_toggled(button_pressed):
	var stream = get_node("Music")
	if get_node("MusicSlider/isMusicOn").is_pressed():
		stream.volume_db = linear2db(get_node("MusicSlider").value/100.0)
		globals.music_toggle = true
		globals.UpdateFile()
	else: 
		stream.volume_db = -80
		globals.music_toggle = false
		globals.UpdateFile()
	pass # Replace with function body.


# warning-ignore:unused_argument
func _on_isSfxOn_toggled(button_pressed):
	var stream = $SFX
	if get_node("SfxSlider/isSfxOn").is_pressed():
		stream.volume_db = linear2db(get_node("SfxSlider").value/100.0)
		globals.sfx_toggle = true
		globals.UpdateFile()
	else: 
		stream.volume_db = -80
		globals.sfx_toggle = false
		globals.UpdateFile()
	pass # Replace with function body.


func _on_SfxSlider_value_changed(value):
	var stream = get_node("SFX")
	stream.volume_db = linear2db(value/100.0)
	if value!=globals.sfx_volume:
		globals.sfx_volume = value
		globals.sfx_toggle = true
		$SfxSlider/isSfxOn.pressed=true
		globals.UpdateFile()
	pass # Replace with function body.


func _on_Back_NG_pressed():
	$SFX.stream = button_back_sfx
	$SFX.play()
	play_ng_sfx = true
	$NG_menu.visible = false
	$VBoxContainer.visible = true
	$MODS.visible = true
	pass 

func isalphanum(c) -> bool:
	return c>='0' && c<='9' || c>='a' && c<='z' || c>='A' && c<='Z'

func _on_SavegameInput_text_changed(new_text):
	if new_text.length()>0 && !isalphanum(new_text[new_text.length()-1]):
		new_text.erase(new_text.length()-1,1)
		$NG_menu/SavegameInput.text=new_text
		$NG_menu/SavegameInput.caret_position=new_text.length()
	pass

func _on_Savegames_pressed():
	if buttons_disabled:
		return
	$SFX.stream = button_press_sfx
	$SFX.play()
	$Savegames_menu.visible = true
	$VBoxContainer.visible = false
	var files = globals.list_files_in_directory(globals.savefile_dir,"dat")
	var number_of_saves = files.size()
	var savegames = $Savegames_menu/Savegame_slots.get_children()
	for i in range(0,number_of_saves):
		savegames[i].visible = true
		savegames[i].text = files[i]
	pass # Replace with function body.


func _on_Back_pressed():
	$SFX.stream=button_back_sfx
	$SFX.play()
	$Savegames_menu.visible=false
	$VBoxContainer.visible = true
	pass # Replace with function body.

func SlotChosen(node):
	$Savegames_menu/Savegame_slots.visible = false
	$Savegames_menu/Back.visible = false
	$"Savegames_menu/Slot Options".visible = true
	slot_node = node
	pass

func _on_slot1_pressed():
	$SFX.stream = button_press_sfx
	$SFX.play()	
	SlotChosen($Savegames_menu/Savegame_slots/slot1)
	pass 


func _on_slot2_pressed():
	$SFX.stream = button_press_sfx
	$SFX.play()
	SlotChosen($Savegames_menu/Savegame_slots/slot2)
	pass # Replace with function body.


func _on_slot3_pressed():
	$SFX.stream = button_press_sfx
	$SFX.play()
	SlotChosen($Savegames_menu/Savegame_slots/slot3)
	pass # Replace with function body.


func _on_slot4_pressed():
	$SFX.stream = button_press_sfx
	$SFX.play()
	SlotChosen($Savegames_menu/Savegame_slots/slot4)
	pass # Replace with function body.


func _on_slot5_pressed():
	$SFX.stream = button_press_sfx
	$SFX.play()
	SlotChosen($Savegames_menu/Savegame_slots/slot5)
	pass # Replace with function body.


func _on_slot6_pressed():
	$SFX.stream = button_press_sfx
	$SFX.play()
	SlotChosen($Savegames_menu/Savegame_slots/slot6)
	pass # Replace with function body.


func _on_slot7_pressed():
	$SFX.stream = button_press_sfx
	$SFX.play()
	SlotChosen($Savegames_menu/Savegame_slots/slot7)
	pass # Replace with function body.


func _on_slot8_pressed():
	$SFX.stream = button_press_sfx
	$SFX.play()
	SlotChosen($Savegames_menu/Savegame_slots/slot8)
	pass # Replace with function body.


func _on_slot9_pressed():
	$SFX.stream = button_press_sfx
	$SFX.play()
	SlotChosen($Savegames_menu/Savegame_slots/slot9)
	pass # Replace with function body.


func _on_slot10_pressed():
	$SFX.stream = button_press_sfx
	$SFX.play()
	SlotChosen($Savegames_menu/Savegame_slots/slot10)
	pass # Replace with function body.


func _on_Back_Slot_pressed():
	if rmv_popup_choice==false:
		$SFX.stream = button_back_sfx
		$SFX.play()
	$Savegames_menu/Savegame_slots.visible = true
	$Savegames_menu/Back.visible = true
	$"Savegames_menu/Slot Options".visible = false
	pass # Replace with function body.

func _on_Remove_pressed():
	if slot_node.text==globals.default_savegame:
		$"Savegames_menu/Remove".dialog_text="    Are you sure you want to remove this savegame?\n       You will have to select another one as default."
		$Savegames_menu/Remove.get_cancel().text = "Cancel"
		$Savegames_menu/Remove.get_ok().text = "Ok"
	else:
		$"Savegames_menu/Remove".dialog_text = "     Are you sure you want to remove this savegame?"
		$Savegames_menu/Remove.get_cancel().text = "No"
		$Savegames_menu/Remove.get_ok().text = "Yes"
	$"Savegames_menu/Remove".popup()
	$SFX.stream = dialogue_popup_sfx
	$SFX.play()
	$Savegames_menu.visible=false
	yield($"Savegames_menu/Remove","popup_hide")
	$Savegames_menu.visible=true
	if(rmv_popup_choice==false):
		return
	rmv_popup_choice=false
	globals.default_savegame="#"
	globals.UpdateFile()
	$VBoxContainer/Continue.visible=false
	var dir = Directory.new()
	dir.remove(globals.savefile_dir + slot_node.text)
	slot_node.visible=false
	_on_Back_Slot_pressed()
	pass 

func _on_Default_pressed():
	$SFX.stream = button_press_sfx
	$SFX.play()
	globals.default_savegame=slot_node.text
	globals.UpdateFile()
	$VBoxContainer/Continue.visible=true
	_on_Back_Slot_pressed()
	pass 

func Load_Game(savegame) -> void:
	var svg=File.new()
	svg.open(globals.savefile_dir+savegame,File.READ)
	var svg_content=svg.get_as_text()
	svg.close()
	globals.current_savegame = savegame
	
	var lvls = globals.Load(savegame)
	if typeof(lvls)==TYPE_DICTIONARY:
		if lvls.has("anger"):
			globals.player_level["anger"]=lvls["anger"]
		if lvls.has("empathy"):
			globals.player_level["empathy"]=lvls["empathy"]
		if lvls.has("pragmatism"):
			globals.player_level["pragmatism"]=lvls["pragmatism"]
		
	if svg_content=="" || (str2var(svg_content).has("NG") && str2var(svg_content)["NG"]==true):
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/NG.tscn")
	else:
# warning-ignore:return_value_discarded
		if str2var(svg_content).has("Tutorial") && str2var(svg_content)["Tutorial"]==false:
			if str2var(svg_content).has("checkpoint") && str2var(svg_content)["checkpoint"]=="purple_planet":
				get_tree().change_scene("res://scenes/purple_planet.tscn")
			else: 
				get_tree().change_scene("res://scenes/world.tscn")
		elif str2var(svg_content).has("Tutorial") && str2var(svg_content)["Tutorial"]==true:
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://scenes/planet.tscn")
		else:
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://scenes/overworld.tscn")
		pass 
	pass

func fade_out(stream_player):
	# tween music volume down to 0
	tween_out.interpolate_property(stream_player, "volume_db", - linear2db(globals.music_volume/100.0), -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()

#func fade_in(stream_player):
#	tween.interpolate_property(stream_player, "volume_db", -80, - linear2db(globals.music_volume/100.0), transition_duration, transition_type, Tween.EASE_IN, 0)
#	tween.start()

# warning-ignore:unused_argument
func _on_TweenOut_tween_completed(object, key):
	# stop the music -- otherwise it continues to run at silent volume
	object.stop()

func _on_Continue_pressed():
	if buttons_disabled:
		return
	$VBoxContainer.visible=false
	$MODS.visible=false
	$SvgName_Continue.dialog_text = "Continue on savegame:\n" + globals.default_savegame + " ?"
	$SvgName_Continue.popup()
	$SFX.stream = dialogue_popup_sfx
	$SFX.play()
	yield($SvgName_Continue,"popup_hide")
	if continue_popup_choice==true:
		fading = true
		$SFX.stream = impact_sfx
		$SFX.play()
		timer = get_tree().create_timer(3.5)
		yield(timer, "timeout")
# warning-ignore:return_value_discarded
		Load_Game(globals.default_savegame)
		continue_popup_choice=false
	else:
		$VBoxContainer.visible = true
		$MODS.visible=true
	pass 

func _on_SvgName_Continue_confirmed():
	fade_out($Music)
	continue_popup_choice = true
	$SvgName_Continue.hide()
	pass

func _on_Remove_confirmed():
	$SFX.stream = button_press_sfx
	$SFX.play()
	rmv_popup_choice=true
	$"Savegames_menu/Remove".hide()
	pass

func _on_Load_pressed():
	$SFX.stream = button_press_sfx
	$SFX.play()
	if globals.default_savegame=="#":
		globals.default_savegame = slot_node.text
		globals.UpdateFile()
	Load_Game(slot_node.text)
	pass # Replace with function body.

func _on_SvgPopUp_popup_hide():
	if popup_choice == false:
		$SFX.stream = button_press_sfx
		$SFX.play()
	pass 


func _on_SvgErrPopUp_confirmed():
	$SFX.stream = button_press_sfx
	$SFX.play()
	pass 


func _on_SvgName_Continue_popup_hide():
	if continue_popup_choice == false:
		$SFX.stream = button_back_sfx
		$SFX.play()
	pass 

func _on_Remove_popup_hide():
	if rmv_popup_choice==false:
		$SFX.stream = button_back_sfx
		$SFX.play()
	pass # Replace with function body.


func _on_Fade_CheckButton_toggled(button_pressed):
	globals.fadecheck = button_pressed
	globals.UpdateFile()
	pass 

func subdirs(path):
	var dir = Directory.new()
	var s = []
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():        
				if file_name!="." && file_name!="..":
					s.append(file_name)
			file_name = dir.get_next()
	return s

onready var spacingres = preload("res://scenes/spacing.tscn")

func _on_mods_checkbox_pressed(button_pressed,scene):
	var path = OS.get_executable_path().get_base_dir()
	path+="/mods/"
	path+=scene.get_node("Label").text
	path+="/disabled.tgl"
	var dir = Directory.new()
	var file = File.new()
	file.open(path,File.WRITE)
	if button_pressed == false:
		dir.remove(path)
		file.store_string("disabled")
		file.close()
	else:
		dir.remove(path)
	if scene.get_node("Label").text == "sound":
		sound_maker(scene)
	pass

func CreateKeybindings(path):
	var file = File.new()
	file.open(path+"keybindings.json",File.WRITE)
	var dict = {"action_up" : "W"}
	dict["action_pragmatism"] = "J"
	dict["action_empathy"] = "G"
	dict["action_anger"] = "Y"
	dict["action_interact"] = "E"
	dict["action_shoot"] = "SPACE"
	dict["action_restart"] = "R"
	dict["action_fastbrake"] = "CONTROL"
	dict["action_brake"] = "S"
	dict["action_boost"] = "W"
	dict["pause"] = "ESCAPE"
	dict["action_skip"] = "F"
	dict["action_left"] = "A"
	dict["action_right"] = "D"
	file.store_string(var2str(dict))
	pass

func Remap(keys_dict,path) -> void:
	keys_dict = str2var(keys_dict)
	if typeof(keys_dict)!=TYPE_DICTIONARY:
		var dir = Directory.new()
		dir.remove(path+"keybindings.json")
		path.erase(path.length()-1,1)
		dir.remove(path)
	else:
		var file = File.new()
		file.open("user://keybindings.json",File.READ_WRITE)
		var default = file.get_as_text()
		var defaults = str2var(default)
		var actions = ["action_right","action_left","action_skip",\
		"pause","action_boost","action_brake","action_fastbrake", \
		"action_restart","action_shoot","action_interact","action_anger",\
		"action_empathy","action_pragmatism"]
		for a in actions:
			if keys_dict.has(a) && (OS.find_scancode_from_string(keys_dict[a])):
				var ev = InputEventKey.new()
				ev.scancode = OS.find_scancode_from_string(defaults[a])
				InputMap.action_erase_event(a,ev)
				ev.scancode = OS.find_scancode_from_string(keys_dict[a])
				InputMap.action_add_event(a, ev)
				defaults[a]=keys_dict[a]
		
		file.store_string(var2str(defaults))
		var dir = Directory.new()
		dir.remove(path+"keybindings.json")
		path.erase(path.length()-1,1)
		dir.remove(path)
	return

func Check_Activity(scene):
	var file = File.new()
	var path = OS.get_executable_path().get_base_dir()
	path+="/mods/"
	path+=scene.get_node("Label").text
	path+="/"
	### keybind
	if scene.get_node("Label").text == "keybindings":
		if !file.file_exists(path+"keybindings.json"):
			var default = {"action_up" : "W"}
			default["action_pragmatism"] = "J"
			default["action_empathy"] = "G"
			default["action_anger"] = "Y"
			default["action_interact"] = "E"
			default["action_shoot"] = "SPACE"
			default["action_restart"] = "R"
			default["action_fastbrake"] = "CONTROL"
			default["action_brake"] = "S"
			default["action_boost"] = "W"
			default["pause"] = "ESCAPE"
			default["action_skip"] = "F"
			default["action_left"] = "A"
			default["action_right"] = "D"
			file.open(path+"keybindings.json",File.WRITE)
			file.store_string(var2str(default))
		else:
			file.open(path+"keybindings.json",File.READ_WRITE)
			if file.get_as_text()=="":
				var default = {"action_up" : "W"}
				default["action_pragmatism"] = "J"
				default["action_empathy"] = "G"
				default["action_anger"] = "Y"
				default["action_interact"] = "E"
				default["action_shoot"] = "SPACE"
				default["action_restart"] = "R"
				default["action_fastbrake"] = "CONTROL"
				default["action_brake"] = "S"
				default["action_boost"] = "W"
				default["pause"] = "ESCAPE"
				default["action_skip"] = "F"
				default["action_left"] = "A"
				default["action_right"] = "D"	
				file.store_string(var2str(default))
			else:
				var s = file.get_as_text()
				file.close()
				Remap(s,path)
	### keybind
	
	
	path+="disabled.tgl"
	if file.file_exists(path):
		file.open(path,File.READ)
		if file.get_as_text()=="disabled":
			scene.get_node("CheckBox").pressed = false
		file.close()
	### SUNETE ###	
	pass
	
func sound_maker(scene):
	var undisabled = scene.get_node("CheckBox").pressed
	if undisabled:
		var file=File.new()
		var path_s = OS.get_executable_path().get_base_dir()+"/mods/sound"
		file.open(path_s,File.READ_WRITE)
		if file.file_exists(path_s+"/button_advance.wav"):
			file.open(path_s+"/button_advance.wav", file.READ)
			var buffer = file.get_buffer(file.get_len())
			button_press_sfx.data = buffer
			
		if file.file_exists(path_s+"/button_back.wav"):
			file.open(path_s+"/button_back.wav", file.READ)
			var buffer = file.get_buffer(file.get_len())
			button_back_sfx.data = buffer
			
		if file.file_exists(path_s+"/attention_popup.wav"):
			file.open(path_s+"/attention_popup.wav", file.READ)
			var buffer = file.get_buffer(file.get_len())
			attention_popup_sfx.data = buffer
			
		if file.file_exists(path_s+"/dialogue_popup.wav"):
			file.open(path_s+"/dialogue_popup.wav", file.READ)
			var buffer = file.get_buffer(file.get_len())
			dialogue_popup_sfx.data = buffer
			
		if file.file_exists(path_s+"/low-impact.wav"):
			file.open(path_s+"/low-impact.wav", file.READ)
			var buffer = file.get_buffer(file.get_len())
			impact_sfx.data = buffer
			
		if file.file_exists(path_s+"/quit.wav"):
			file.open(path_s+"/quit.wav", file.READ)
			var buffer = file.get_buffer(file.get_len())
			quit_sfx.data = buffer
			
		#var main_menu_theme = preload("res://soundtrack/main_theme.wav")
		if file.file_exists(path_s+"/main_theme.wav"):
			file.open(path_s+"/main_theme.wav", file.READ)
			var buffer = file.get_buffer(file.get_len())
			main_menu_theme.data = buffer
			music_player.stop()
			music_player.stream = main_menu_theme
			music_player.play()
	else:
		var file=File.new()
		file.open("res://sfx/button_advance.wav", file.READ)
		var buffer = file.get_buffer(file.get_len())
		button_press_sfx.data = buffer
		
		file.open("res://sfx/button_back.wav", file.READ)
		buffer = file.get_buffer(file.get_len())
		button_back_sfx.data = buffer
		
		file.open("res://sfx/attention_popup.wav", file.READ)
		buffer = file.get_buffer(file.get_len())
		attention_popup_sfx.data = buffer
		
		file.open("res://sfx/dialogue_popup.wav", file.READ)
		buffer = file.get_buffer(file.get_len())
		dialogue_popup_sfx.data = buffer
		
		file.open("res://sfx/low-impact.wav", file.READ)
		buffer = file.get_buffer(file.get_len())
		impact_sfx.data = buffer
		
		file.open("res://sfx/quit.wav", file.READ)
		buffer = file.get_buffer(file.get_len())
		quit_sfx.data = buffer
	

func init_mods():
	var mods = subdirs(OS.get_executable_path().get_base_dir()+"/mods")
	for mod_name in mods:
		var scene = modres.instance()
		globals.mod_instances.append(scene)
		scene.get_node("CheckBox").connect("toggled",self,"_on_mods_checkbox_pressed", [scene])
		var space = spacingres.instance()
		globals.mod_spacing_instances.append(space)
		scene.get_node("Label").text = mod_name
		Check_Activity(scene)
		$mods_menu/ScrollContainer/VBoxContainer.add_child(scene)
		$mods_menu/ScrollContainer/VBoxContainer.add_child(space)
	pass

func _on_MODS_pressed():
	$mods_menu.visible=true
	$VBoxContainer.visible=false
	$MODS.visible=false
	pass 


func _on_Back_mods_pressed():
	$mods_menu.visible=false
	$VBoxContainer.visible=true
	$MODS.visible=true
	pass 


func _on_Button_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open(OS.get_executable_path().get_base_dir()+"/mods")
	pass # Replace with function body.


func _on_Music_finished():
	music_player.play()
	pass # Replace with function body.
