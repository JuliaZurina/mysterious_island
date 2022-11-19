extends KinematicBody2D

onready var hitbox = $HitBox/CollisionShape2D
onready var timer = $HitBox/Timer
onready var animatesprite = $AnimatedSprite

func _ready():
	hitbox.disabled = true
	animatesprite.frame = 0
	animatesprite.play("attack")
	
	timer.wait_time = 1.17

func _on_Timer_timeout():
	hitbox.disabled = false


func _on_AnimatedSprite_animation_finished():
	hitbox.disabled = true
