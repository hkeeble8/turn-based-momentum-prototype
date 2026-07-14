class_name Direction

enum {NONE, UP, DOWN, LEFT, RIGHT}
static var direction_strings = ["none", "up", "down", "left", "right"]

static func to_vector(direction) -> Vector2:
	match direction:
		UP: return Vector2.UP
		DOWN: return Vector2.DOWN
		LEFT: return Vector2.LEFT
		RIGHT: return Vector2.RIGHT
		_: return Vector2.ZERO

static func from_vector(vector: Vector2) -> int:
	if vector == Vector2.ZERO:
		return NONE

	var best_dir = UP
	var best_dot = -1.0
	for dir in [UP, DOWN, LEFT, RIGHT]:
		var dot = vector.dot(to_vector(dir))
		if dot > best_dot:
			best_dot = dot
			best_dir = dir
	return best_dir

static func to_str(direction: int) -> String:
	return direction_strings[direction]
