extends Area2D
onready var hitBox = $HitBox/CollisionShape2D
onready var animatedsprite = $AnimatedSprite
onready var hitBoxTimer = $hitboxtimer
#var player = null

func _ready():
	hitBox.disabled = true
	hitBoxTimer.wait_time = 0.8
	animatedsprite.frame = 0
	animatedsprite.play("attack")

	
func _on_AnimatedSprite_animation_finished():
	animatedsprite.frame = 0
	animatedsprite.play("poof")
	
func _on_Timer_timeout():
	queue_free()


func _on_hitboxtimer_timeout():
	hitBox.disabled = false
