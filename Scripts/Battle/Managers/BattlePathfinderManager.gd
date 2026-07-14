class_name BattlePathfinderManager
extends Node

var pathfinder: AStarGrid2D

var valid_move_directions: Array[Vector2i] = [
	Vector2i.RIGHT, Vector2i.LEFT, Vector2i.UP, Vector2i.DOWN
]

func _init():
	pathfinder = AStarGrid2D.new()

func register_tile_map_layers(tile_map_layers: TileMapLayerCollection) -> void:
	_assert_tile_map_layers(tile_map_layers)

	pathfinder.region = tile_map_layers.region
	pathfinder.cell_size = Vector2(BattleGlobals.CONFIG.cell_size, BattleGlobals.CONFIG.cell_size)
	pathfinder.offset = Vector2.ZERO
	pathfinder.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	pathfinder.update()

	_set_solid_points(tile_map_layers)

func get_cell_path(from_cell: Vector2i, to_cell: Vector2i, allow_partial_path: bool = false) -> Array[Vector2i]:
	if ((from_cell < Vector2i.ZERO && from_cell > pathfinder.size) || (from_cell < Vector2i.ZERO && from_cell > pathfinder.size)):
		return []
	
	# The from point should never be solid (it may be solid if we're starting from an actor's position)
	# Let's temporarily ensure it is not.
	var from_cell_is_solid = pathfinder.is_point_solid(from_cell)
	set_cell_solid(from_cell, false)
	
	var id_path: Array[Vector2i] = pathfinder.get_id_path(from_cell, to_cell, allow_partial_path)
	# We know where we're starting, so remove this as it's not useful data
	if !id_path.is_empty():
		id_path.remove_at(0)

	if from_cell_is_solid:
		set_cell_solid(from_cell, true)
	
	return id_path

func set_cell_solid(cell: Vector2i, is_solid: bool) -> void:
	pathfinder.set_point_solid(cell, is_solid)

# BFS
func get_reachable_cells(start_cell: Vector2i, max_distance: int) -> Array[Vector2i]:
	var reachable: Array[Vector2i] = []
	var visited: Dictionary = {}
	var queue: Array = []

	queue.append({"cell": start_cell, "dist": 0})
	visited[start_cell] = true

	while queue.size() > 0:
		var current = queue.pop_front()
		var cell: Vector2i = current["cell"]
		var dist: int = current["dist"]

		if dist > max_distance:
			continue

		reachable.append(cell)

		for dir in valid_move_directions:
			var next = cell + dir
			if visited.has(next):
				continue
			if next.x >= 0 && next.x < pathfinder.region.size.x && next.y >= 0 && next.y < pathfinder.region.size.y:
				if pathfinder.is_point_solid(next):
					continue
			visited[next] = true
			queue.append({"cell": next, "dist": dist + 1})

	reachable.erase(start_cell)
	return reachable

func _set_solid_points(tile_map_layers: TileMapLayerCollection) -> void:
	for x in tile_map_layers.region.size.x:
		for y in tile_map_layers.region.size.y:
			_update_cell_solid(Vector2i(x, y), tile_map_layers.layers)

func _update_cell_solid(cell: Vector2i, tile_map_layers: Array[TileMapLayer]) -> void:
	for tile_map_layer in tile_map_layers:
		if tile_map_layer.get_cell_source_id(cell) != -1:
				pathfinder.set_point_solid(cell,
					tile_map_layer.get_cell_tile_data(cell)
						.get_custom_data(BattleGlobals.TILEMAP_SOLID_DATA_LAYER) == true)

func _assert_tile_map_layers(tile_map_layers: TileMapLayerCollection) -> void:
	if OS.is_debug_build():
		for layer in tile_map_layers.layers:
			assert(layer.get_used_rect().position >= Vector2i.ZERO,
            "For the current pathfinding implementation, all TileMapLayers must not be below 0,0!"
		)
