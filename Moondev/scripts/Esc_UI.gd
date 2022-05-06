extends CanvasLayer

var is_paused = false setget set_is_paused
var quit_sound = preload("res://sfx/quit.wav")
var menu_sound = preload("res://sfx/button_back.wav")
var resume_sound = preload("res://sfx/button_advance.wav")
var popup_sound = preload("res://sfx/dialogue_popup.wav")
var back_sound = menu_sound
var quit_confirm:=false
var mainmenu_confirm:=false

func _ready():
	$SFX.volume_db = linear2db(globals.sfx_volume/100.0)

func _unhandled_input(event):
	if event.is_action_pressed("pause") && globals.allow_pause:
		self.is_paused = !is_paused
		if is_paused:
			$SFX.stream = back_sound
		else:
			$SFX.stream = resume_sound
		$SFX.play()

func set_is_paused(value):
	is_paused = value
	if is_paused == false && globals.is_paused_by_other_means == true:
		pass
	else:
		get_tree().paused = is_paused
	$Background.visible = is_paused
	$CenterContainer.visible = is_paused
	if is_paused == true:
		$CenterContainer/VBoxContainer/ResumeButton.grab_focus()
	


func _on_ResumeButton_pressed():
	$SFX.stream = resume_sound
	$SFX.play()
	self.is_paused = false
	


func _on_QuitButton_pressed():
	$CenterContainer.visible = false
	$SFX.stream = quit_sound
	$SFX.play()
	yield($SFX,"finished")
	get_tree().quit()


func _on_MainMenuButton_pressed():
	self.is_paused = false
	$CenterContainer.visible = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/main_menu.tscn")
	pass 
