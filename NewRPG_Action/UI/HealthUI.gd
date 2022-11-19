extends Control

var hearts = 3 setget set_hearts
var max_hearts = 3 setget set_max_hearts

const stats = preload("res://stats.gd")

onready var heartUIFull = $HealthUIFull
onready var heartUIEmpty = $HealthUIEmpty 



func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * 15
	
func set_max_hearts(value):
	max_hearts = max(value, 1)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * 15

func _ready():
	self.max_hearts = PlayerStats.max_life
	self.hearts = PlayerStats.life
# warning-ignore:return_value_discarded
	PlayerStats.connect("life_change", self, "set_hearts")
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_life_change", self, "set_max_hearts")
	

