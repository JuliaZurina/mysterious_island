extends KinematicBody2D

onready var animatedsprite = $Sprite

func _ready():
	animatedsprite.frame = 0
	animatedsprite.play("default")

func _on_Timer_timeout():
	queue_free()
