extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal done
signal chosen

var choice:String=""
var choice_time = 0
var initial_choice_time = 0
var is_choice_timed := false
var active:=false
var angerlvl:int=0
var empathylvl:int=0
var pragmatismlvl:int=0
var path:String
var yielding := false
var autoproceed := false
onready var initial_arrow_position_x = $TimeSlider/Sprite.position.x
var final_arrow_position_x := 768
var arrow_distance
# Called when the node enters the scene tree for the first time.
func _ready():
	arrow_distance = final_arrow_position_x - initial_arrow_position_x
	pass

func show(option_anger:String,option_empathy:String,option_pragmatism:String, \
		anger_needed:int=0,empathy_needed:int=0,pragmatism_needed:int=0, \
		 __is_choice_timed=false,__choice_time=0):
	get_parent().get_tree().paused = true
	$ColorRect.visible = true
	$anger.visible = true
	$empathy.visible = true
	$pragmatism.visible = true
	active = true
	is_choice_timed=__is_choice_timed
	if __is_choice_timed:
		$TimeLabel.visible=true
		$TimeSlider.visible=true
		choice_time=__choice_time
		initial_choice_time=__choice_time
	$anger/Choice.text=option_anger
	$empathy/Choice.text=option_empathy
	$pragmatism/Choice.text=option_pragmatism
	angerlvl=anger_needed
	empathylvl=empathy_needed
	pragmatismlvl=pragmatism_needed
	yield(self,"chosen")
	globals.option = choice
	choice = ""
	$ColorRect.visible = false
	$anger.visible = false
	$empathy.visible = false
	$pragmatism.visible = false
	$TimeSlider.visible = false
	$TimeLabel.visible = false
	$TimeSlider/Sprite.position.x = initial_arrow_position_x
	get_parent().get_tree().paused = false
	pass

func Animate() -> void:
	path = "res://scenes/png_res/"
	if choice == "anger":
		path+="y"
	elif choice == "empathy":
		path+="G"
	else:
		path+="J"
	get_node(choice).get_node("Key").texture = load(path+"key_inverted.png")
	pass

func _process(delta):
	if active:
		if Input.is_action_just_released("action_anger") || Input.is_action_just_released("action_empathy") || Input.is_action_just_released("action_pragmatism"):
			yielding = false
			emit_signal("done")
		###############    RESULT OF FATE   #################
		if yielding && choice_time < 0:
			yielding = false
			emit_signal("done")
		elif is_choice_timed && choice_time < 0:
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			var number = rng.randi()
			if number<0: number = -number
			number %= 3
			
			if number==0:
				choice = "anger"
			elif number==1:
				choice = "empathy"
			else:
				choice = "pragmatism"
			autoproceed = true
		#####################################################
		if is_choice_timed && choice_time >= 0:
			choice_time -= delta
			$TimeSlider/Sprite.position.x += arrow_distance/initial_choice_time * delta
				
		if !yielding:
			if Input.is_action_just_pressed("action_anger"):
				choice = "anger"
				pass
			elif Input.is_action_just_pressed("action_empathy"):
				choice = "empathy"
				pass
			elif Input.is_action_just_pressed("action_pragmatism"):
				choice = "pragmatism"
				pass
				
			if choice!="":
				var settings = globals.Load()
				if settings.has("choice"):
					settings[choice]+=1
					globals.player_level[choice]+=1
				else:
					settings[choice]=0
				globals.Save(settings)
		# warning-ignore:return_value_discarded
				if !autoproceed:
					Animate()
					yielding = true
					yield(self,"done")
					yielding = false
					get_node(choice).get_node("Key").texture = load(path+"key.png")
				is_choice_timed = false
				active = false
				autoproceed = false
				choice_time=0
				initial_choice_time=0
				$anger/Choice.text=""
				$empathy/Choice.text=""
				$pragmatism/Choice.text=""
				angerlvl=0
				empathylvl=0
				pragmatismlvl=0
				emit_signal("chosen")
	pass
