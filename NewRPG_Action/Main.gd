extends Node2D
onready var player = $NewWorld/People/Player_3
onready var firecooldown = $CanvasLayer/CoolDown/Fire
onready var icecooldown = $CanvasLayer/CoolDown/Ice
onready var watercooldown = $CanvasLayer/CoolDown/Water


var  is_paused = false setget set_is_paused
var can_interact = false

func  set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _ready():
	PlayerStats.life = 3
	WraithStats.health = 65
	$NewWorld/People/Bearded_NPC.visible = true
	$Pit/WhiteFlame.hide()
	$NewWorld/People/Enemies/Wraith.show()
	$CanvasLayer/Control/Button.show()
	$CanvasLayer/Control/Enter.visible = false
	$WinLoseCanvas/WinMenu.visible = false
	$WinLoseCanvas/LoseMenu.visible = false
	$CanvasLayer/Control.visible = false
	$CanvasLayer/PauseMenu.visible = false
	$Pit/Polygon2D.visible = false
	$Pit/Interact.visible = false
	$Area2D/Polygon2D.visible = false
	$Area2D2/TreesLabel.visible = false
	$Area2D2/TreesLabel2.visible = false
	firecooldown.max_value = 15
	icecooldown.max_value = 25
	watercooldown.max_value = 100

func _process(delta):
	firecooldown.value = player.firespell_cooldown.tick(delta)
	icecooldown.value = player.icespell_cooldown.tick(delta)
	watercooldown.value = player.waterspell_cooldown.tick(delta)

func _physics_process(delta):
	if WraithStats.health <= 0:
		$WinLoseCanvas/WinMenu.visible = true
		$WinLoseCanvas/WinMenu/WinMusic.play()
		$NewWorld/NewWorldMusic.stop()
		$WinLoseCanvas/LoseMenu.visible = false
		
	elif WraithStats.health == WraithStats.max_health:
		$WinLoseCanvas/WinMenu.visible = false
	
		
	if PlayerStats.life <= 0:
		$WinLoseCanvas/LoseMenu.visible = true
		$People/Player_3/PlayerRespawnTimer.stop()
		$NewWorld/NewWorldMusic.stop()
		$LoseMusic.play()
		
	else:
		$WinLoseCanvas/LoseMenu.visible = false
		$LoseMusic.stop()
		
	

func _on_Button_pressed():
	$CanvasLayer/Control.visible = false
	$CanvasLayer/PauseMenu.visible = true


func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://Menu/Menu.tscn")


func _on_ControlsButton_pressed():
	$CanvasLayer/PauseMenu.visible = false
	self.is_paused = !is_paused
	$CanvasLayer/Control.visible = true


func _on_Area2D_body_entered(body):
	if body.name == "Player_3":
		$Area2D/Polygon2D.visible = true

func _on_Area2D_body_exited(body):
	$Area2D/Polygon2D.visible = false


func _on_Area2D2_body_entered(body):
	if body.name == "Player_3":
		$Area2D2/TreesLabel.visible = true
		$Area2D2/TreesLabel2.visible = true

func _on_Area2D2_body_exited(body):
	$Area2D2/TreesLabel.visible = false
	$Area2D2/TreesLabel2.visible = true

func _on_Pit_body_entered(body):
	if body.name == "Player_3":
		can_interact = true
		$Pit/Interact.visible = true
		$Pit/WhiteFlame.show()

func _on_Pit_body_exited(body):
	can_interact = false
	$Pit/Polygon2D.visible = false
	$Pit/Interact.visible = false

func _input(event):
	if Input.is_key_pressed(KEY_E) and can_interact == true:
		$Pit/Polygon2D.visible = true


func _on_ChangeMusic_body_entered(body):
	if body.name == "Player_3":
		$NewWorldMusic.stop()
		$ChangeMusic/AreaChangeBgMusic.play()


func _on_ChangeMusic_body_exited(body):
	$ChangeMusic/AreaChangeBgMusic.stop()
	$NewWorldMusic.play()
