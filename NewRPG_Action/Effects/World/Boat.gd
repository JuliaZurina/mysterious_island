extends KinematicBody2D

onready var velocity = Vector2.ZERO
onready var acceleration = 40

func _ready():
	$Arrow.visible = false
	$door.disabled = false
	$Pirate1/Polygon2D.visible = false
	$Pirate1/RichTextLabel.visible = false
	$Area2D2/Polygon2D.visible = false
	$Area2D2/RichTextLabel.visible = false
	
func _physics_process(delta):
	velocity = Vector2(1, 0)
	move_and_collide(velocity.normalized() * acceleration * delta)


func _on_Timer_timeout():
	velocity = Vector2.ZERO
	$door.disabled = true
	$Arrow.visible = true
	$Arrow/AnimationPlayer.play("Arrow")



func _on_Area2D_body_entered(body):
	if body.name == "Player_3":
		$Pirate1/Polygon2D.visible = true
		$Pirate1/RichTextLabel.visible = true


func _on_Area2D_body_exited(body):
	if body.name == "Player_3":
		$Pirate1/Polygon2D.visible = false
		$Pirate1/RichTextLabel.visible = false # Replace with function body.


func _on_Area2D2_body_entered(body):
	if body.name == "Player_3":
		$Area2D2/Polygon2D.visible = true
		$Area2D2/RichTextLabel.visible = true


func _on_Area2D2_body_exited(body):
	if body.name == "Player_3":
		$Area2D2/Polygon2D.visible = false
		$Area2D2/RichTextLabel.visible = false # Replace with function body.
