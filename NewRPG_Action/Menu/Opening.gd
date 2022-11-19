extends Control

var sentence = "Dear brave Warrior, You are sent to Volmor island to vanquish evil that has been consuming and threatening the lives of its people. Find the source, fight it and save the people."
var sen_index = 0


func _on_Timer_timeout():
	if sen_index < sentence.length():
		$Panel/RichTextLabel.append_bbcode(sentence[sen_index])
		sen_index += 1

func _on_Button_pressed():
	get_tree().change_scene("res://Menu/ControlsMenu.tscn")
