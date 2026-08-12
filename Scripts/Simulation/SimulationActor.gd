class_name SimulationActor
extends Node2D

signal position_changed()
signal collision(area: Area2D)
signal sighted(area: Area2D)

@export var id: String
var entity_id: int

@export_group("Static Sprite")
@export_enum("NONE", "UP", "DOWN", "LEFT", "RIGHT") var flip_sprite_horizontal: int = 0
@export_enum("NONE", "UP", "DOWN", "LEFT", "RIGHT") var flip_sprite_vertical: int = 0

var animated_sprite: AnimatedSprite2D
var static_sprite: Sprite2D
var collision_area: Area2D
var interact_area: Area2D
var sight_area: Area2D

var move_speed: float = 60.0
var move_direction: int
var move_path_target_idx: int
var move_path: Array[Vector2i]

var is_moving: bool = false

func _ready() -> void:
	animated_sprite = get_node_or_null("AnimatedSprite2D")
	static_sprite = get_node_or_null("Sprite2D")
	collision_area = get_node_or_null("CollisionArea")
	interact_area = get_node_or_null("InteractArea")
	sight_area = get_node_or_null("SightArea")

	set_facing(Direction.DOWN)
	_init_collision_areas()

func _process(delta: float) -> void:
	if !move_path.is_empty():
		_process_move(delta)

func serialize() -> Dictionary:
	return {
		"id": id
	}

static func deserialize(data: Dictionary) -> SimulationActor:
	return SimulationActorRegistry.get_actor_scene(data["id"]).instantiate()

func get_current_cell() -> Vector2i:
	# TODO - could we just cache this?
	return BattleGrid.world_to_cell(position)

func set_facing(direction: int) -> void:
	_set_sprite_direction(direction)

func move_on_path(path: Array[Vector2i]) -> void:
	move_path = path
	move_path_target_idx = 0
	is_moving = true
	_update_move_direction()

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
	position_changed.emit()
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
	is_moving = false
	_set_sprite_direction(move_direction)

func _init_collision_areas() -> void:
	if collision_area != null:
		collision_area.area_entered.connect(_on_collision)
	if sight_area != null:
		sight_area.area_entered.connect(_on_sighted)

func _on_collision(area: Area2D) -> void:
	collision.emit(area)

func _on_sighted(area: Area2D) -> void:
	sighted.emit(area)
