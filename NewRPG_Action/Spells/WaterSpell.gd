extends KinematicBody2D

onready var animatedsprite = $AnimatedSprite

func _ready():
	animatedsprite.frame = 0
	animatedsprite.play("default")

func _on_Timer_timeout():
	queue_free()



func _on_AnimatedSprite_animation_finished():
	animatedsprite.frame = 0
	animatedsprite.play("waterend")
