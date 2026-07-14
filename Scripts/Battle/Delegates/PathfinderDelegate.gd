class_name PathfinderDelegate
extends IPathfinder

var manager: BattlePathfinderManager

func _init(pf_manager: BattlePathfinderManager) -> void:
	manager = pf_manager

func get_cell_path(from_cell: Vector2i, to_cell: Vector2i, allow_partial_path: bool = false) -> Array[Vector2i]:
	return manager.get_cell_path(from_cell, to_cell, allow_partial_path)

func get_reachable_cells(start_cell: Vector2i, max_distance: int) -> Array[Vector2i]:
	return manager.get_reachable_cells(start_cell, max_distance)
