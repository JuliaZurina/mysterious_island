extends AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	play("radius")

func _on_Timer_timeout():
	queue_free()
