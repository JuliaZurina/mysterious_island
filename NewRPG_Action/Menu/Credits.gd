extends Control

var sentence = "That is all for this version of the game, Thank You for your time. I hope you find fun and satisfaction by this game.                                                                                      Sincerely, Devolopers."
var sen_index = 0


func _on_Timer_timeout():
	if sen_index < sentence.length():
		$Panel/RichTextLabel.append_bbcode(sentence[sen_index])
		sen_index += 1


func _on_QuitButton_pressed():
	get_tree().quit()
