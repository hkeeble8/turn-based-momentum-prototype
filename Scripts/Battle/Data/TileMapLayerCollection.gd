class_name TileMapLayerCollection
extends Resource

var layers: Array[TileMapLayer]
var region: Rect2i

func _init(new_tile_map_layers: Array[TileMapLayer]):
	layers = new_tile_map_layers
	_init_region()

func _init_region() -> void:
	var largest_region = Rect2i(0, 0, 0, 0)
	for layer in layers:
		var layer_rect_size = layer.get_used_rect().size
		if layer_rect_size.x > largest_region.size.x:
			largest_region.size.x = layer_rect_size.x
		if layer_rect_size.y > largest_region.size.y:
			largest_region.size.y = layer_rect_size.y
	region = largest_region
