extends KinematicBody2D

onready var hitbox = $HitBox/CollisionShape2D
onready var timer = $HitBox/Timer
onready var animatesprite = $AnimatedSprite
onready var playerDetection = $PlayerDet
onready var stats = $Stats
onready var hurtbox = $HurtBox

onready var speed = 20
const chase_speed = 80

onready var state = MOVE

enum{
	IDLE,
	MOVE,
	CHASE,
	FROZEN
}
enum{
	MOVE_LEFT,
	MOVE_RIGHT,
	MOVE_UP,
	MOVE_DOWN
}
onready var mobility = MOVE_RIGHT

func _ready():
	hitbox.disabled = true
	animatesprite.frame = 0
	animatesprite.play("walk")
		
	timer.wait_time = 1.17
	
func _process(delta):
	$ProgressBar.value = stats.health
	
func _physics_process(delta):
	var velocity = Vector2.ZERO
	
	match state:
		IDLE:
			pass
		MOVE:
			match mobility:
				MOVE_LEFT:
					_seek_player()
					animatesprite.flip_h = true
					velocity = Vector2(-1,0)
				MOVE_RIGHT:
					_seek_player()
					animatesprite.flip_h = false
					velocity = Vector2(1,0)
				MOVE_UP:
					_seek_player()
					velocity = Vector2(0,-1)
				MOVE_DOWN:
					_seek_player()
					velocity = Vector2(0,1)
		CHASE:
			var player = playerDetection.player
			if playerDetection.can_see_player():
				animatesprite.play("attack")
				if velocity.x < 0:
					animatesprite.flip_h = true
				if velocity.x > 0:
					animatesprite.flip_h = false
				velocity = position.direction_to(player.position)
# warning-ignore:return_value_discarded
				move_and_collide(velocity.normalized() * chase_speed * delta)
				
			elif !playerDetection.can_see_player():
					state = MOVE_RIGHT
		FROZEN:
			velocity = Vector2.ZERO
		
	move_and_collide(velocity.normalized() * speed * delta)

func _on_Timer_timeout():
	hitbox.disabled = false

func _on_AnimatedSprite_animation_finished():
	hitbox.disabled = true
	
func _pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _seek_player():
	if playerDetection.can_see_player():
		state = CHASE


func _on_HurtBox_area_entered(area):
	if area.name == "IceSpell":
		state = FROZEN
	stats.health -= area.damage
	hurtbox.create_hit_effect()


func _on_HurtBox_area_exited(area):
	pass # Replace with function body.
