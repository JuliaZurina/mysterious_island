extends KinematicBody2D
onready var ani_sprite = $Sprite
var velocity = Vector2.ZERO
var speed = 150

func _physics_process(delta):
	ani_sprite.play("default")
# warning-ignore:unused_variable
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)


func _on_Timer_timeout():
	queue_free()
