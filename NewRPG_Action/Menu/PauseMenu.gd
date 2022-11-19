extends Control

var  is_paused = false setget set_is_paused


func _ready():
	$CenterContainer/VBoxContainer/ResumeButton.grab_focus()



func  set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		var new_pause_state = not get_tree().paused
		self.is_paused = new_pause_state
		visible = new_pause_state

func _on_ResumeButton_pressed():
	self.is_paused = !is_paused

func _on_MainMenuButton_pressed():
# warning-ignore:return_value_discarded
	self.is_paused = !is_paused
	get_tree().change_scene("res://Menu/Menu.tscn")
