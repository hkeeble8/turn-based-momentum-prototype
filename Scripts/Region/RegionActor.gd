class_name RegionActor
extends Node2D

@export_group("Static Sprite")
@export_enum("NONE", "UP", "DOWN", "LEFT", "RIGHT") var flip_sprite_horizontal: int = 0
@export_enum("NONE", "UP", "DOWN", "LEFT", "RIGHT") var flip_sprite_vertical: int = 0

@export_group("Simulation")
@export var definitions: Array[SimulationEntityDefinition]

@onready var animated_sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D")
@onready var static_sprite: Sprite2D = get_node_or_null("Sprite2D")

var move_speed: float = 120.0
var move_direction: int
var move_path_target_idx: int
var move_path: Array[Vector2i]

var is_busy: bool = false
var is_moving: bool = false

func _ready() -> void:
	set_facing(Direction.DOWN)

func _process(delta: float) -> void:
	if is_busy:
		if !move_path.is_empty():
			_process_move(delta)

func get_current_cell() -> Vector2i:
	# TODO - could we just cache this?
	return BattleGrid.world_to_cell(position)

func set_facing(direction: int) -> void:
	_set_sprite_direction(direction)

func _set_sprite_direction(direction: int) -> void:
	var direction_string = Direction.to_str(direction)
	if animated_sprite:
		_set_animated_sprite_direction(direction_string)
	elif static_sprite:
		_set_static_sprite_direction(direction_string)

func _set_animated_sprite_direction(direction_string: String) -> void:
	var anim_prefix = RegionGlobals.IDLE_ANIMATION_PREFIX
	if is_moving:
		anim_prefix = RegionGlobals.MOVE_ANIMATION_PREFIX
	var animation_name = anim_prefix + direction_string
	if animated_sprite.sprite_frames.has_animation(animation_name):
		animated_sprite.play(animation_name)

func _set_static_sprite_direction(direction_string: String) -> void:
	if flip_sprite_horizontal != null && flip_sprite_horizontal != -1:
		static_sprite.flip_h = direction_string == Direction.to_str(flip_sprite_horizontal)
	if flip_sprite_vertical != null && flip_sprite_vertical != -1:
		static_sprite.flip_v = direction_string == Direction.to_str(flip_sprite_vertical)

func move_on_path(path: Array[Vector2i]) -> void:
	move_path = path
	move_path_target_idx = 0
	is_busy = true
	is_moving = true
	_update_move_direction()

func _process_move(delta: float) -> void:
	var distance_to_target = BattleGrid.cell_to_world(move_path[move_path_target_idx]) - position
	var step = move_speed * delta

	if distance_to_target.length() <= step:
		position = BattleGrid.cell_to_world(move_path[move_path_target_idx])
		move_path_target_idx += 1
		_update_move_direction()
	else:
		position += distance_to_target.normalized() * min(step, distance_to_target.length())

func _update_move_direction() -> void:
	if move_path_target_idx >= move_path.size():
		_end_move()
	else:
		var delta: Vector2i = move_path[move_path_target_idx] - get_current_cell()
		var new_move_direction = Direction.from_vector(Vector2i(sign(delta.x), sign(delta.y)))
		if move_direction != new_move_direction:
			move_direction = new_move_direction
			_set_sprite_direction(move_direction)

func _end_move() -> void:
	move_path.clear()
	move_path_target_idx = 0
	is_busy = false
	is_moving = false
	_set_sprite_direction(move_direction)