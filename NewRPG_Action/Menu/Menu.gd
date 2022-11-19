extends Control

func _ready():
	$VBoxContainer/NewGameButton.grab_focus()

func _on_NewGameButton_pressed():
	get_tree().change_scene("res://Menu/Opening.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_ContinueButton_pressed():
	get_tree().change_scene("res://Main.tscn")
