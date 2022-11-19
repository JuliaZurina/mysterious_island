extends KinematicBody2D

onready var animate = $AnimatedSprite
onready var playerDetection = $PlayerDet
onready var stateTimer = $StateTimer
onready var stats = $stats
onready var hurtbox = $HurtBox

onready var WRAITHDIEEFFECT = preload("res://Effects/WraithDieEffect.tscn")

const speed = 40
const max_speed = 70
const dash_speed = 120

func _ready():
	$HitBox/CollisionShape2D.disabled = true
	$HitBox/HitboxTimerBlink.wait_time = 0.5
	$HitBox/HitboxTimer.wait_time = 1
	state = _pick_random_state([ROAM_DOWN, ROAM_UP, MOVE_LEFT, MOVE_RIGHT, CHASE, DASH])
	stateTimer.wait_time = rand_range(1, 3)

enum{
	ROAM_DOWN,
	ROAM_UP,
	MOVE_LEFT,
	MOVE_RIGHT,
	FROZEN,
	CHASE,
	DASH
}
var minimap_icon = "Enemy"
var state = DASH
var velocity = Vector2.ZERO

func _process(delta):
	if WraithStats.health <= 65:
		WraithStats.health += 0.1 * delta
	$ProgressBar.value = WraithStats.health


func _physics_process(delta):
	match state:
		ROAM_DOWN:
			_roam_down(delta)
			
		ROAM_UP:
			_roam_up(delta)
			
		MOVE_LEFT:
			_roam_left(delta)
			
		MOVE_RIGHT:
			_roam_right(delta)
			
		FROZEN:
			velocity = Vector2.ZERO
			
		CHASE:
			var player = playerDetection.player
			if playerDetection.can_see_player():
				animate.play("wraith_move")
				if velocity.x < 0:
					animate.flip_h = true
				if velocity.x > 0:
					animate.flip_h = false
				velocity = position.direction_to(player.position)
# warning-ignore:return_value_discarded
				move_and_collide(velocity.normalized() * max_speed * delta)
				
			elif !playerDetection.can_see_player():
					state = MOVE_RIGHT
				
		DASH:
			animate.play("wraith_move")
			if velocity.x < 0:
				animate.flip_h = true
			if velocity.x > 0:
				animate.flip_h = false
			var player = playerDetection.player
			if playerDetection.can_see_player():
				velocity = position.direction_to(player.position)
# warning-ignore:return_value_discarded
				move_and_collide(velocity.normalized() * dash_speed * delta)
				
			elif !playerDetection.can_see_player():
				state = MOVE_LEFT
	
	
func _pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _seek_player():
	if playerDetection.can_see_player():
		state = _pick_random_state([CHASE, DASH])
		
func _on_StateTimer_timeout():
	state = _pick_random_state([ROAM_DOWN, ROAM_UP, MOVE_LEFT, MOVE_RIGHT, CHASE, DASH])

func _roam_up(delta):
	animate.play("wraith_move")
	animate.flip_h = false
	velocity = Vector2(0, -1)
# warning-ignore:return_value_discarded
	move_and_collide(velocity.normalized() * speed * delta)
	_seek_player()

func _roam_down(delta):
	animate.play("default")
	velocity = Vector2(0, 1)
# warning-ignore:return_value_discarded
	move_and_collide(velocity.normalized() * speed * delta)
	_seek_player()

func _roam_right(delta):
	animate.play("wraith_move")
	animate.flip_h = false
	velocity = Vector2(1, 0)
# warning-ignore:return_value_discarded
	move_and_collide(velocity.normalized() * speed * delta)
	_seek_player()
	
func _roam_left(delta):
	_seek_player()
	animate.play("wraith_move")
	animate.flip_h = true
	velocity = Vector2(-1, 0)
# warning-ignore:return_value_discarded
	move_and_collide(velocity.normalized() * speed * delta)
	_seek_player()

func _on_HurtBox_area_entered(area):
	if area.name == "Icespell":
		state = FROZEN
	WraithStats.health -= area.damage
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)
	if WraithStats.health <= 0:
		_on_stats_no_health()

func _on_stats_no_health():
#	queue_free()
	hide()
	var wraithdieeffect = WRAITHDIEEFFECT.instance()
	get_parent().add_child(wraithdieeffect)
	wraithdieeffect.global_position = global_position
	

func _on_HurtBox_area_exited(_area):
	state = _pick_random_state([ROAM_DOWN, ROAM_UP, MOVE_LEFT, MOVE_RIGHT, CHASE, DASH])


func _on_HitboxTimerBlink_timeout():
	$HitBox/CollisionShape2D.disabled = false


func _on_HitboxTimer_timeout():
	$HitBox/CollisionShape2D.disabled = true
