extends Area2D
onready var animate = $NecroticSpell2
onready var hitbox = $Fear/CollisionShape2D
onready var timer = $Timer

func _ready():
	timer.wait_time = 0.1
	hitbox.disabled = true
	animate.frame = 0
	animate.play("default")


func _on_Timer_timeout():
	hitbox.disabled = false


func _on_NecroticSpell2_animation_finished():
	queue_free()
