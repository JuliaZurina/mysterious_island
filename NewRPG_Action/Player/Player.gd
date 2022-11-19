extends KinematicBody2D

var swordspellpath = preload("res://SwordSpell.tscn")

const acceleration = 700
const max_speed = 80
const friction = 500

func _ready():
	animationtree.active = true

enum{
	MOVE,
	ATTACK,
	ROLL
}


var state = MOVE
var velocity = Vector2.ZERO	
onready var animationplayer = $AnimationPlayer
onready var animationtree = $AnimationTree
onready var animationstate = animationtree.get("parameters/playback")

func attack_state(delta):
	animationstate.travel("Attack")

func spell_cast(delta):
	var swordspell = swordspellpath.instance()
	get_parent().add_child(swordspell)
	swordspell.position = $Node2D/Position2D.global_position
	swordspell.velocity = get_global_mouse_position() - swordspell.position

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ROLL:
			pass
			

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		animationtree.set("parameters/Idle/blend_position",input_vector)
		animationtree.set("parameters/Run/blend_position",input_vector)
		animationtree.set("parameters/Attack/blend_position",input_vector)
		animationstate.travel("Run")
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)

	else:
		animationstate.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("Attack"):
		velocity = Vector2.ZERO
		state = ATTACK
		
	if Input.is_action_just_pressed("Spellcast_1"):
		$Node2D.look_at(get_global_mouse_position())
		spell_cast(delta)
		
func attack_animation_end():
	state = MOVE
		
