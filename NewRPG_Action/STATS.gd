extends Node

export(int) var max_health = 1 setget set_max_health
export(int) var max_mana = 1 setget set_max_mana
export(int) var max_life = 1 setget set_max_life

var health = max_health setget set_health
var mana = max_mana setget set_mana
var life = max_life setget set_life

signal no_health
signal health_change(value)
signal max_health_change(value)
signal no_mana
signal mana_change(value)
signal max_mana_change(value)
signal no_life
signal life_change(value)
signal max_life_change(value)


func set_max_life(value):
	max_life = value
	self.life = min(life, max_life)
	emit_signal("max_life_change", max_life)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_change", max_health)

func set_health(value):
	health = value
	emit_signal("health_change", health)
	if health <= 0:
		emit_signal("no_health")

func set_max_mana(value):
	max_mana = value
	self.mana = min(mana, max_mana)
	emit_signal("max_mana_change", max_mana)
	
func set_life(value):
	life = value
	emit_signal("life_change", life)
	if life <= 0:
		emit_signal("no_life")

func set_mana(value):
	mana = value
	emit_signal("mana_change", mana)
	if mana <= 0:
		emit_signal("no_mana")
		
func _ready():
	self.health = max_health
	self.mana = max_mana
	self.life = max_life

