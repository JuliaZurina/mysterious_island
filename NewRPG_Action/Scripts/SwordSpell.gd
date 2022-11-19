extends KinematicBody2D
onready var ani_sprite = $AnimatedSprite

var velocity = Vector2.ZERO
var speed = 150

func _physics_process(delta):
	ani_sprite.play("default")
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)
	
	if collision_info != null:
	 velocity = position.direction_to(ani_sprite.position) * delta * speed
