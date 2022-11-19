extends TextureButton

export var cooldown_time = 1
var isRun = false

func _ready():
	$Label.hide()
	$TextureProgress.value = 0
	$TextureProgress.texture_progress = texture_normal
	$Timer.wait_time = cooldown_time
	set_process(false)
	
func _process(delta):
	$Label.text = "%0.1f" % $Timer.time_left
	$TextureProgress.value = int(($Timer.time_left/cooldown_time)*100)
	pass

func _on_Timer_timeout():
	isRun = false
	$Label.hide()
	$TextureProgress.value = 0
	set_process(false)


func _on_TextureButton_pressed():
	if isRun == false:
		isRun = true
		$Label.show()
		$Timer.start()
		set_process(true)
	pass # Replace with function body.
