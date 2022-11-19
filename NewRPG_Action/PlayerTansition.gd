extends Position2D
onready var player = preload("res://Player_3/Player_3.tscn")



func _on_PlayerTransition_body_entered(body):
	var PLAYER = player.instance()
	get_parent().add_child(PLAYER)
