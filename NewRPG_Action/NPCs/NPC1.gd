extends KinematicBody2D

onready var DIALOG = preload("res://NPCs/Dialog.tscn")

onready var ani_sprite = $AnimatedSprite
onready var timer = $Timer
onready var speed = 30
onready var area = $Area2D
onready var questionmark = $QuestionMark

var active = false
var velocity
var can_interact = false

const CHAR_READ_RATE = 0.5

enum{
	ROAM_RIGHT,
	ROAM_LEFT,
	IDLE
}
var state = ROAM_RIGHT

func _ready():
	$RichTextLabel.visible = false
	$CanvasLayer.visible = false
	timer.wait_time = 3
	$IdleWait.wait_time = 6
	
# warning-ignore:unused_argument
func _process(delta):
	questionmark.visible = active

func _physics_process(delta):
	match state:
		ROAM_RIGHT:
			move_right()
		ROAM_LEFT:
			move_left()
		IDLE:
			idle_state()
			
# warning-ignore:return_value_discarded
	move_and_collide(velocity.normalized() * speed * delta)
	
func move_right():
	velocity = Vector2(1,0)
	ani_sprite.flip_h = true
	ani_sprite.play("walkleft")

func move_left():
	timer.autostart = true
	velocity = Vector2(-1,0)
	ani_sprite.flip_h = false

func idle_state():
	$WalkRightTimer.stop()
	timer.stop()
	$IdleWait.start()
	ani_sprite.play("Idle")
	velocity = Vector2.ZERO
	
func _pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func _on_IdleWait_timeout():
	state = ROAM_LEFT

func _on_Timer_timeout():
	state = ROAM_RIGHT


func _on_Area2D_body_entered(body):
	if body.name == "Player_3":
		$RichTextLabel.visible = true
		can_interact = true
		active = true
		state = IDLE
		

func _on_Area2D_body_exited(body):
	if body.name == "Player_3":
		can_interact = false
		active = false
		$RichTextLabel.visible = false
		$CanvasLayer.visible = false
		timer.start()
		$WalkRightTimer.start()
		state = ROAM_LEFT

# warning-ignore:unused_argument
func _input(event):
		if Input.is_key_pressed(KEY_E) and can_interact == true:
			$CanvasLayer.visible = true
	


func _on_WalkRightTimer_timeout():
	state = ROAM_RIGHT
