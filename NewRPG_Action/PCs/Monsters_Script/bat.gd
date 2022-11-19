extends KinematicBody2D

export(int) var MAX_Speed = 50
export(int) var acceleration = 300
export(int) var friction = 200
export(int) var knockback_friction = 50
export(int) var WANDER_TARGET_RANGE = 4
onready var damage = 1

enum{
	IDLE,
	WANDER,
	CHASE 
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = CHASE

onready var deatheffectpath = preload("res://Effects/DeathEffect.tscn")
onready var fireaballgd = preload("res://Spells/FireBall.gd")
onready var PlayerDetectionZone = $PlayerDet
onready var softcollision = $SoftCollisions
onready var wanderController = $WanderController
onready var hurtbox = $HurtBox
onready var animate = $Sprite
onready var stat = $Stat


func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_friction * delta)
	knockback = move_and_slide(knockback)
	print (stat.health)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_toward(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
		CHASE:
			var player = PlayerDetectionZone.player
			if player != null: 
				accelerate_toward(player.global_position, delta)
			else:
				state = IDLE
				
	if softcollision.is_colliding():
		velocity += softcollision.get_push_vector() * delta * 400
		velocity = move_and_slide(velocity)
	
func accelerate_toward(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_Speed, acceleration * delta)
	animate.flip_h = velocity.x < 0
		
func update_wander():
  state = pick_random_state([IDLE, WANDER])
  wanderController.start_wander_timer(rand_range(1, 3))

func pick_random_state(state_list):
  state_list.shuffle()
  return state_list.pop_front()

func seek_player():
	if PlayerDetectionZone.can_see_player():
		state = CHASE
  
