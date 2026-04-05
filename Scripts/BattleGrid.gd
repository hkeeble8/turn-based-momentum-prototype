class_name BattleGrid

static func world_to_cell(world_pos: Vector2i) -> Vector2i:
	@warning_ignore("integer_division")
	return world_pos / BattleGlobals.CELL_SIZE

static func cell_to_world(cell_pos: Vector2i) -> Vector2:
	return cell_pos * BattleGlobals.CELL_SIZE

static func direction(source_cell: Vector2i, target_cell: Vector2i) -> Vector2:
	return Vector2(target_cell - source_cell).normalized()

static func distance(source_cell: Vector2i, target_cell: Vector2i) -> int:
	return floor(source_cell.distance_to(target_cell))