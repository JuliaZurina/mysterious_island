extends KinematicBody2D
onready var demobat_move = $Sprite

const EnemyDealthEffect = preload("res://Effects/DeathEffect.tscn")

export var MAX_Speed = 65
export var acceleration = 300
export var friction = 200
export var WANDER_TAEGET_RANGE = 6 
export var damage = 4

var velocity = Vector2.ZERO
var state = CHASE

onready var sprite = $Sprite
onready var stats = $stats
onready var playerDetectionZone = $PlayerDet
onready var hurtbox = $HurtBox
onready var SoftCollision = $SoftCollisions
onready var wanderController = $WanderController


enum{
	IDLE,
	WANDER,
	CHASE,
	FROZEN
}

func _ready():
	$FrozenTimer.stop()
	state = pick_random_state([IDLE, WANDER])
	
func _process(delta):
	$ProgressBar.value = stats.health
	
func _physics_process(delta):

	match state:
		IDLE:
			sprite.play("demonbat")
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()


		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_toward(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= WANDER_TAEGET_RANGE:
				update_wander()


		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_toward(player.global_position, delta)
			else:
				state = IDLE
		
		FROZEN:
			$FrozenTimer.start()
			velocity = Vector2.ZERO
			
	if SoftCollision.is_colliding():
		velocity += SoftCollision.get_push_vector() * delta * 400
		
	velocity = move_and_slide(velocity)
	
func accelerate_toward(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_Speed, acceleration * delta)
	sprite.play("demobat_move")
	sprite.flip_h = velocity.x > 0
			
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
		
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))
		
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_HurtBox_area_entered(area):
	if area.name == "Icespell":
		state = FROZEN
	stats.health -= area.damage
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)
	if stats.health <= 0:
		_on_stats_no_health()

func _on_stats_no_health():
	queue_free()
	var enemyDealthEffect = EnemyDealthEffect.instance()
	get_parent().add_child(enemyDealthEffect)
	enemyDealthEffect.global_position = global_position
	
func _on_HurtBox_area_exited(area):
	state = WANDER
	

func _on_FrozenTimer_timeout():
	state = pick_random_state([CHASE, WANDER])
