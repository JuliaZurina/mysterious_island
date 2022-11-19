extends Node2D


func _on_Area2D_body_entered(body):
	if body.name == "Player_3":
		get_tree().change_scene("res://Main.tscn")
		
func _process(delta):
	$ElvenShip/Player_3/HealthBar.visible = false
	$ElvenShip/Player_3/ManaBar.visible = false
