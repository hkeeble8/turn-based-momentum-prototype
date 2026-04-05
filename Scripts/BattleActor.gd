class_name BattleActor
extends Node2D

signal turn_finished(actor: BattleActor)
signal position_changed(actor: BattleActor)
signal eliminated(actor: BattleActor)
signal action_completed(actor: BattleActor)

@export var data: BattleActorData
@export var is_player_controlled: bool = false
@export var brain: BattleBrain
@export var team: int

@export_group("Static Sprite")
@export_enum("UP", "DOWN", "LEFT", "RIGHT") var flip_sprite_horizontal: int = -1
@export_enum("UP", "DOWN", "LEFT", "RIGHT") var flip_sprite_vertical: int = -1

@onready var animated_sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D")
@onready var static_sprite: Sprite2D = get_node_or_null("Sprite2D")

var is_busy: bool = false
var is_moving: bool = false

var health_current: int
var action_points_current: int
var movement_points_current: int

var move_speed: float = 120.0
var move_direction: Vector2i
var move_path_target_idx: int
var move_path: Array[Vector2i]

var skills: Array[BattleSkill] = []

func _ready() -> void:
	set_facing(Vector2.DOWN)
	health_current = data.health_max
	action_points_current = data.action_points_max
	movement_points_current = data.movement_points_max
	skills = data.skills

func _process(delta: float) -> void:
	if is_busy:
		if !move_path.is_empty():
			_process_move(delta)

func start_turn() -> void:
	movement_points_current = data.movement_points_max
	action_points_current = data.action_points_max

func notify_turn_finished() -> void:
	turn_finished.emit(self )

func get_current_cell() -> Vector2i:
	# TODO - could we just cache this?
	return BattleGrid.world_to_cell(position)

func move_on_path(path: Array[Vector2i]) -> void:
	move_path = path
	move_path_target_idx = 0
	is_busy = true
	is_moving = true
	movement_points_current -= path.size()
	_set_next_move_direction()

func use_skill(skill: BattleSkill, target: BattleActor) -> void:
	action_points_current -= 1
	is_busy = true
	set_facing(BattleGrid.direction(get_current_cell(), target.get_current_cell()))
	await _perform_skill_animation(skill, target)
	target.health_current -= 1
	if target.health_current <= 0:
		target.eliminated.emit(target)
	_action_completed()

func set_facing(direction: Vector2) -> void:
	_set_sprite_direction(direction)

func get_sprite() -> Node2D:
	if animated_sprite:
		return animated_sprite
	elif static_sprite:
		return static_sprite
	return null

func _perform_skill_animation(skill: BattleSkill, target: BattleActor) -> void:
	var context = AnimationUtils.create_context(self , target)
	context.value = "1"
	await AnimationUtils.play_battle_animation_event(self , skill.animation,
		context)

func _process_move(delta: float) -> void:
	var distance_to_target = BattleGrid.cell_to_world(move_path[move_path_target_idx]) - position
	var step = move_speed * delta

	if distance_to_target.length() <= step:
		position = BattleGrid.cell_to_world(move_path[move_path_target_idx])
		move_path_target_idx += 1
		_set_next_move_direction()
	else:
		position += distance_to_target.normalized() * min(step, distance_to_target.length())

func _end_move() -> void:
	move_path.clear()
	move_path_target_idx = 0
	is_busy = false
	is_moving = false
	position_changed.emit(self )
	_set_sprite_direction(move_direction)
	_action_completed()

func _set_next_move_direction() -> void:
	if move_path_target_idx >= move_path.size():
		_end_move()
	else:
		var delta: Vector2i = move_path[move_path_target_idx] - get_current_cell()
		move_direction = Vector2i(sign(delta.x), sign(delta.y))
		_set_sprite_direction(move_direction)

func _set_sprite_direction(direction: Vector2) -> void:
	var direction_string = Direction.to_str(Direction.from_vector(direction))
	if animated_sprite:
		_set_animated_sprite_direction(direction_string)
	elif static_sprite:
		_set_static_sprite_direction(direction_string)

func _set_animated_sprite_direction(direction_string: String) -> void:
	var anim_prefix = BattleGlobals.IDLE_ANIMATION_PREFIX
	if is_moving:
		anim_prefix = BattleGlobals.MOVE_ANIMATION_PREFIX
	var animation_name = anim_prefix + direction_string
	if animated_sprite.sprite_frames.has_animation(animation_name):
		animated_sprite.play(animation_name)

func _set_static_sprite_direction(direction_string: String) -> void:
	if flip_sprite_horizontal != null && flip_sprite_horizontal != -1:
		static_sprite.flip_h = direction_string == Direction.to_str(flip_sprite_horizontal)
	if flip_sprite_vertical != null && flip_sprite_vertical != -1:
		static_sprite.flip_v = direction_string == Direction.to_str(flip_sprite_vertical)

func _action_completed() -> void:
	is_busy = false
	action_completed.emit(self )
