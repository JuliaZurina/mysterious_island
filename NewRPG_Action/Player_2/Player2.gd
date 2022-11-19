extends KinematicBody2D
const acceleration = 100
const max_speed = 30
const friction = 500
const MAX_Speed = 500

var velocity = Vector2.ZERO

onready var animationplayer = $AnimationPlayer
onready var animationtree = $AnimationTree
onready var animation = $AnimatedSprite
onready var timer = $Timer
onready var wanderController = $WanderController
onready var walkTimer = $WalkTimer
onready var stats = $stats
onready var hurtbox = $HurtBox
onready var healthbar = $Healthbar

onready var animationstate = animationtree.get("parameters/playback")
onready var purpleballpath = preload("res://Spells/PurplePowerBall.tscn")
onready var clonespellpath = preload("res://Spells/CloneSpell.tscn")
onready var necroticspellpath = preload("res://Spells/Necrotic.tscn")
onready var necroticspell_2Path = preload("res://Spells/Necrotic2.tscn")
onready var cooldown = preload("res://Scripts/Cooldown.gd")
onready var radiuspath = preload("res://Spells/Radius.tscn")
onready var purpleballCooldown = cooldown.new(0.5)
onready var clonespellCooldown = cooldown.new(12)
onready var necroticspell_1Cooldown = cooldown.new(5)
onready var necroticspell_2Cooldown = cooldown.new(8)

var WANDER_TARGET_RANGE = 4
var player = null

enum{
	IDLE,
	WANDER,
	SPELLCAST,
	FROZEN,
	SUMMON
}
var state = IDLE

func _ready():
	
	state = pick_random_state([IDLE, WANDER])
	walkTimer.wait_time = rand_range(1, 3)
	walkTimer.autostart = true
	

func warning_radius():
	var radius = radiuspath.instance()
	radius.position = player.global_position
	get_parent().add_child(radius)
	
	
	
func spell_attack():
	var purpleball = purpleballpath.instance()
	purpleball.player = player
	purpleball.position = $Node2D.global_position
	get_parent().add_child(purpleball)
	
	
func necroticspell_cast(delta):
	var necroticspell = necroticspellpath.instance()
	necroticspell.player = player
	necroticspell.rotation = (player.position - position).angle()
	necroticspell.position = $Node2D.global_position
	get_parent().add_child(necroticspell)
	accelerate_toward(player.global_position, delta)
	
func necroticspell_2_cast():
	var necroticspell2 = necroticspell_2Path.instance()
	necroticspell2.position = player.global_position
	get_parent().add_child(necroticspell2)
	
func clonespell_cast():
	warning_radius()
	var clonespell = clonespellpath.instance()
	clonespell.position = player.global_position
	get_parent().add_child(clonespell)
	

func can_see_player():
	return player != null

func _on_PlayerDet_body_entered(body):
	if player:
		return
	player = body

func _on_PlayerDet_body_exited(body):
	if player == body:
		player = null

func accelerate_toward(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_Speed, acceleration * delta)
	
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 2))
	
func _process(delta):
	
	timer.wait_time = 1
	purpleballCooldown.tick(delta)
	necroticspell_1Cooldown.tick(delta)
	necroticspell_2Cooldown.tick(delta)
	clonespellCooldown.tick(delta)
	
onready var case = WANDER_RIGHT

enum{
	WANDER_LEFT,
	WANDER_RIGHT,
	WANDER_UP,
	WANDER_DOWN
}
func _physics_process(delta):
	healthbar.value = stats.health
	
	match state:
		IDLE:
			_idle()
				
		WANDER:
			match case:
				WANDER_LEFT:
					_wander_left()
				WANDER_RIGHT:
					_wander_right()
				WANDER_DOWN:
					_wander_down()
				WANDER_UP:
					_wander_up()
				
		SPELLCAST:
			_spellcast(delta)
						
		FROZEN:
			velocity = Vector2.ZERO
			
		SUMMON:
			pass
			
# warning-ignore:return_value_discarded
	move_and_collide(velocity.normalized() * max_speed * delta)
	
func _idle():
	animation.play("Idle")
	velocity = Vector2.ZERO
	seek_player()

func _pick_random_case(case_list):
	case_list.shuffle()
	return case_list.pop_front()
	

func _wander_right():
	animation.flip_h = true
	animation.play("MoveLeft")
	velocity = Vector2(1, 0)
	seek_player()

func _wander_left():
	animation.flip_h = false
	animation.play("MoveLeft")
	velocity = Vector2(-1, 0)
	seek_player()
	
func _wander_down():
	animation.play("MoveDown")
	velocity = Vector2(0, 1)
	seek_player()
	
func _wander_up():
	animation.play("MoveUp")
	velocity = Vector2(0, -1)
	seek_player()
	
func _on_WalkTimer_timeout():
	case = _pick_random_case([WANDER_DOWN, WANDER_RIGHT, WANDER_LEFT, WANDER_UP])
	
func _spellcast(delta):
	if can_see_player() and necroticspell_1Cooldown.is_ready():
			necroticspell_cast(delta)
			
	if can_see_player() and necroticspell_2Cooldown.is_ready():
		velocity = Vector2.ZERO
		warning_radius()
		necroticspell_2_cast()
		
	if can_see_player() and purpleballCooldown.is_ready():
		spell_attack()

	if can_see_player() and clonespellCooldown.is_ready():	
		warning_radius()
		clonespell_cast()
		
	else:
		state = WANDER

func seek_player():
	if can_see_player():
		state = SPELLCAST

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Timer_timeout():
	warning_radius()

func _on_HurtBox_area_entered(area):
	if area.name == "Icespell":
		state = FROZEN
	stats.health -= area.damage
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)
	if stats.health <= 0:
		_on_stats_no_health()
		
# warning-ignore:unused_argument
func _on_HurtBox_area_exited(area):
	case = _pick_random_case([WANDER, SPELLCAST])
	
func _on_stats_no_health():
	queue_free()

