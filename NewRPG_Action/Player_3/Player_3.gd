extends KinematicBody2D
const acceleration = 700
const max_speed = 80
const friction = 500
onready var fireballpath = preload("res://Spells/FireBall.tscn")
onready var firespellpath = preload("res://Spells/FireSpell.tscn")
onready var icespellpath = preload("res://Spells/IceSpell.tscn")
onready var waterspellpath = preload("res://Spells/WaterSpell.tscn")
const cooldown = preload("res://Scripts/Cooldown.gd")

onready var stats = $stats
onready var hurtbox = $HurtBox
onready var game_timer = OS.get_ticks_msec()
onready var fireball_cooldown = cooldown.new(0.5)
onready var firespell_cooldown = cooldown.new(15)
onready var icespell_cooldown = cooldown.new(25)
onready var waterspell_cooldown = cooldown.new(100)

var velocity = Vector2.ZERO
var state = MOVE
var STATS = PlayerStats 
onready var animationplayer = $AnimationPlayer
onready var animationtree = $AnimationTree
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var animationstate = animationtree.get("parameters/playback")


enum{
	MOVE,
	STUNNED,
	GHOST
}


#manacosts
var fireball_manacost = 2
var firespell_manacost = 20
var icespell_manacost = 25
var waterspell_manacost = 30


func cant_cast_spell():
	print("No mana")
	$No_Mana.visible = true
	$No_Mana/Timer.start()


func _not_yet():
	print("It's not time yet")
	$On_Cooldown.visible = true
	$On_Cooldown/Timer.start()
	
	

#mana regen
func _mana_regen(delta):
		if stats.mana <= 70:
			stats.mana += 2 * delta

#health regen
func _health_regen(delta):
	if stats.health <= stats.max_health:
		stats.health += 0.1 * delta


# warning-ignore:unused_argument
func _process(delta):
	$HealthBar.max_value = stats.max_health
	$HealthBar.value = stats.health
	$ManaBar.max_value = stats.max_mana
	$ManaBar.value = stats.mana
	
	
func _physics_process(delta):

	fireball_cooldown.tick(delta)
	firespell_cooldown.tick(delta)
	icespell_cooldown.tick(delta)
	waterspell_cooldown.tick(delta)
	
	match state:
		MOVE:
			_mana_regen(delta)
			_health_regen(delta)
			move_state(delta) 
		STUNNED:
			velocity = Vector2.ZERO
		GHOST:
			var input_vector = Vector2.ZERO
			input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
			input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
			input_vector = input_vector.normalized()

			if input_vector != Vector2.ZERO:
				animationtree.set("parameters/Idle/blend_position",input_vector)
				animationtree.set("parameters/Run/blend_position",input_vector)
				animationstate.travel("Run")
				velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	
			else:
				animationstate.travel("Idle")
				velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			velocity = move_and_slide(velocity)
	
func _ready():
	$No_Mana.visible = false
	$On_Cooldown.visible = false
	collision_layer = 2
	animationtree.active = true
	$PlayerRespawnTimer.wait_time = 6
	$PlayerRespawnTimer.stop()

func get_time():
	var current_time = OS.get_ticks_msec() - game_timer
	var seconds = current_time/1000%60
	return str(seconds)
	
func fire_spell_cast(delta):
	if firespell_manacost > stats.mana:
		cant_cast_spell()
	if firespell_cooldown.tick(delta) > 0:
		_not_yet()
	if stats.mana >= firespell_manacost and firespell_cooldown.is_ready():
		stats.mana -= firespell_manacost
		var firespell = firespellpath.instance()
		get_parent().add_child(firespell)
		firespell.position = get_global_mouse_position()
	

func ice_spell_cast(delta):
	if icespell_manacost > stats.mana:
		cant_cast_spell()
	if icespell_cooldown.tick(delta) > 0:
		_not_yet()
	if stats.mana >= icespell_manacost and icespell_cooldown.is_ready():
		stats.mana -= icespell_manacost
		var icespell = icespellpath.instance()
		get_parent().add_child(icespell)
		icespell.position = get_global_mouse_position()
	
func water_spell_cast(delta):
	if waterspell_manacost > stats.mana:
		cant_cast_spell()
	if waterspell_cooldown.tick(delta) > 0:
		_not_yet()
	if stats.mana >= waterspell_manacost and waterspell_cooldown.is_ready():
		stats.mana -= waterspell_manacost
		var waterspell = waterspellpath.instance()
		get_parent().add_child(waterspell)
		waterspell.position = get_global_mouse_position()

func spell_attack():
	if fireball_manacost > stats.mana:
		cant_cast_spell()
	stats.mana -= fireball_manacost
	var fireball = fireballpath.instance()
	get_parent().add_child(fireball)
	fireball.position = $Node2D/Position2D.global_position
	fireball.velocity = get_global_mouse_position() - fireball.position
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		animationtree.set("parameters/Idle/blend_position",input_vector)
		animationtree.set("parameters/Run/blend_position",input_vector)
		animationstate.travel("Run")
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	
	else:
		animationstate.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	velocity = move_and_slide(velocity)

	if Input.is_action_just_pressed("shoot") and fireball_cooldown.is_ready():
		$Node2D.look_at(get_global_mouse_position())
		spell_attack()
	
	if Input.is_action_just_pressed("Spellcast_1"):
		$Node2D.look_at(get_global_mouse_position())
		fire_spell_cast(delta)

	if Input.is_action_just_pressed("Spellcast_2"):
		$Node2D.look_at(get_global_mouse_position())
		ice_spell_cast(delta)
	
	if Input.is_action_just_pressed("Spellcast_3"):
		$Node2D.look_at(get_global_mouse_position())
		water_spell_cast(delta)

func _on_HurtBox_area_entered(area):
	if area.name == "Fear":
		state = STUNNED
	stats.health -= area.damage
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)
	if stats.health <= 0:
		_die()
		$PlayerRespawnTimer.start()
		


func _player_respawn():
	state = MOVE
	collision_layer = 2
	$HealthBar.visible = true
	$ManaBar.visible = true
	$Sprite.modulate = Color(1, 1, 1)


func _die():
	PlayerStats.life -= 1
	if stats.health <= 0 and PlayerStats.life <= 0:
		$PlayerRespawnTimer.stop()

	$HealthBar.visible = false
	$ManaBar.visible = false
	if stats.health <= stats.max_health:
		stats.health += stats.max_health
	if stats.mana <= stats.max_mana:
		stats.mana += stats.max_mana
	collision_layer = 1
	state = GHOST
	$Sprite.modulate = Color( 1, 1, 1, 0.3)
	
func _on_PlayerRespawnTimer_timeout():
	_player_respawn()

func _on_HurtBox_area_exited(area):
	if area.name =="Fear":
		state = MOVE	

func _on_HurtBox_invincibility_started():
	blinkAnimationPlayer.play("start")

func _on_HurtBox_invincibility_ended():
	blinkAnimationPlayer.play("stop")


func _on_Timer_timeout():
	$No_Mana.visible = false
	$On_Cooldown.visible = false
