extends KinematicBody2D

onready var animatedsprite = $AnimatedSprite

func _ready():
	$HurtboxTimer.wait_time = 0.1
	$Icespell/CollisionShape2D.disabled = true
	animatedsprite.frame = 0
	animatedsprite.play("IceSpell")

func _on_Timer_timeout():
	queue_free()
	
func _on_AnimatedSprite_animation_finished():
	animatedsprite.frame = 0
	animatedsprite.play("IceSpell_Fade")

func _on_HurtboxTimer_timeout():
	$Icespell/CollisionShape2D.disabled = false
