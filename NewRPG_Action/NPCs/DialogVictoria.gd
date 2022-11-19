extends CanvasLayer

const CHAR_READ_RATE = 0.05

onready var textureRect = $TextureRect
onready var start_symbol = $TextureRect/HBoxContainer/start
onready var label = $TextureRect/HBoxContainer/Label
onready var name_cap = $TextureRect/HBoxContainer2/name

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []

func _ready():
	$Timer.stop()
	$Timer.wait_time = 15
	print("Starting state to: State.READY")
	hide_textbox()
	_load_text()

func _load_text():
	queue_text("Hello young girl") 
	queue_text("Are you here to help us?") 
	queue_text("The evil is growing bigger and bigger day by day") 
	queue_text("The North West part of the island is where the evil resites, be careful..") 

# warning-ignore:unused_argument
func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.empty():
				display_text()
			

		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				label.percent_visible = 1.0
				$Tween.stop_all()
				change_state(State.FINISHED)
			
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
				hide_textbox()
				$Timer.start()
				
		
func queue_text(next_text):
	text_queue.push_back(next_text)
	
func hide_textbox():
	start_symbol.text = ""
	label.text = ""
	textureRect.hide()
	
func show_textbox():
	start_symbol.text = "*"
	name_cap.text = "Victoria"
	textureRect.show()
	
func display_text():
	var next_text = text_queue.pop_front()
	label.text= next_text
	label.percent_visible = 0.0
	change_state(State.READING)
	show_textbox()
	$Tween.interpolate_property(label, "percent_visible", 0.0, 1.0, len(next_text) * CHAR_READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("Changing state to: State.READY")

		State.READING:
			print("Changing state to: State.READING")

		State.FINISHED:
			print("Changing state to: State.FINISHED")

		State.RELOAD:
			print("Changing state to: State.RELOAD")
			
func _on_Tween_tween_all_completed():
	change_state(State.FINISHED)


func _on_Timer_timeout():
	if text_queue.empty():
		_load_text()
