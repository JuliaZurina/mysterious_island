extends Control

var  is_paused = false setget set_is_paused

func _ready():
	$ColorRect9/Node2D/AnimationPlayer.play("cursorMove")
	$Button.hide()

func  set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_Enter_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Effects/World/BoatScene.tscn")
