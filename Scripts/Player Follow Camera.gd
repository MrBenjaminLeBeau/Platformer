extends Camera2D

@export var tilemap: TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	var map_rect = tilemap.get_used_rect()
	var tile_size = tilemap.cell_quadrant_size
	var upper_left_corner = map_rect.position * tile_size
	var lower_right_corner = (map_rect.position + map_rect.size) * tile_size
	
	limit_left = tilemap.position.x + upper_left_corner.x
	limit_top = tilemap.position.y + upper_left_corner.y
	limit_right = tilemap.position.x + lower_right_corner.x
	limit_bottom = tilemap.position.y + lower_right_corner.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
