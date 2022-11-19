extends MarginContainer

export (NodePath) var player
export var zoom = 1.5

onready var grid = $MarginContainer/Grid
onready var player_marker = $MarginContainer/Grid/PlayerIndicator
onready var enemy_marker = $MarginContainer/Grid/EnemyIndicator

onready var icons = {"Enemy": enemy_marker}
var grid_scale
var markers = {}

func _ready():
	player_marker.position = grid.rect_size / 2
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)
	var map_objects = get_tree().get_nodes_in_group("MiniMap_Enemies")
	for item in map_objects:
		var new_marker = icons[item.minimap_icon].duplicate()
		grid.add_child(new_marker)
		new_marker.show()
		markers[item] = new_marker
		
func _process(delta):
	for item in markers:
		var obj_pos = (item.position - get_node(player).position) * grid_scale + grid.rect_size / 2
		if grid.get_rect().has_point(obj_pos + grid.rect_position):
			markers[item].scale = Vector2(.8,.8)
		else:
			markers[item].scale = Vector2(.5,.5)
			
		obj_pos.x = clamp(obj_pos.x, 0 , grid.rect_size.x)
		obj_pos.y = clamp(obj_pos.y, 0 , grid.rect_size.y)
		markers[item].position = obj_pos
