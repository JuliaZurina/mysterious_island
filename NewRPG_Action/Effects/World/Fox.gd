extends KinematicBody2D
onready var velocity = Vector2.ZERO

const acceleration = 700

var state = RIGHT


func _ready():
	pass
	
enum{
	LEFT,
	RIGHT,
	UP,
	DOWN,
	SLEEP,
	AFFRAID
}
func _move_left():
	velocity = Vector2.LEFT
	
func _move_right():
	velocity = Vector2.RIGHT
	
func _move_up():
	velocity = Vector2.UP
	
func _move_down():
	velocity = Vector2.DOWN
	
func _physics_process(delta):
	match state:
		LEFT:
			_move_left()
		RIGHT:
			_move_right()
		UP:
			pass
		DOWN:
			pass
		SLEEP:
			pass
		AFFRAID:
			pass
			
	velocity = move_and_slide(velocity) * acceleration * delta
