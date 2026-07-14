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
@export_enum("NONE", "UP", "DOWN", "LEFT", "RIGHT") var flip_sprite_horizontal: int = 0
@export_enum("NONE", "UP", "DOWN", "LEFT", "RIGHT") var flip_sprite_vertical: int = 0

@onready var animated_sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D")
@onready var static_sprite: Sprite2D = get_node_or_null("Sprite2D")

var is_eliminated: bool = false
var is_busy: bool = false
var is_moving: bool = false

var guard_current: int
var momentum_current: int
var action_points_current: int
var movement_points_current: int

var move_speed: float = 120.0
var move_direction: int
var move_path_target_idx: int
var move_path: Array[Vector2i]

var skills: Array[BattleSkill] = []
var engagements: Array[BattleActor] = []

func _ready() -> void:
	set_facing(Direction.DOWN)
	guard_current = data.guard_max
	momentum_current = 0

	action_points_current = data.action_points_max
	movement_points_current = data.movement_points_max
	skills = data.skills

func _process(delta: float) -> void:
	if is_busy:
		if !move_path.is_empty():
			_process_move(delta)

func start_turn() -> void:
	if !is_engaged():
		adjust_guard(1)
	movement_points_current = data.movement_points_max
	action_points_current = data.action_points_max

func notify_turn_finished() -> void:
	turn_finished.emit(self)

func get_current_cell() -> Vector2i:
	# TODO - could we just cache this?
	return BattleGrid.world_to_cell(position)

func move_on_path(path: Array[Vector2i]) -> void:
	move_path = path
	move_path_target_idx = 0
	is_busy = true
	is_moving = true
	movement_points_current -= path.size()
	_update_move_direction()

func use_skill(skill: BattleSkill, target: BattleActor, fire_event: bool = true) -> void:
	var skill_direction = Direction.from_vector(BattleGrid.direction(get_current_cell(), target.get_current_cell()))
	var damage = _calculate_attack_damage(skill_direction)
	action_points_current -= 1
	is_busy = true
	momentum_current = 0

	target.take_damage(damage, skill_direction)
	if skill.is_engaging:
		_add_engagement(target)

	set_facing(skill_direction)
	await _perform_skill_animation(skill, target, damage)
	
	_action_completed(fire_event)

func set_facing(direction: int) -> void:
	_set_sprite_direction(direction)

func take_damage(damage: int, from_direction: int) -> void:
	var guard_damage = damage
	if move_direction == from_direction:
		guard_damage = max(damage - momentum_current, 0)
		adjust_momentum(-damage)
	else:
		momentum_current = 0
	adjust_guard(-guard_damage)
	if guard_current <= 0:
		set_eliminated()

func adjust_momentum(value: int) -> void:
	momentum_current = clamp(momentum_current + value, 0, data.momentum_max)

func adjust_guard(value: int) -> void:
	guard_current = clamp(guard_current + value, 0, data.guard_max)

func get_sprite() -> Node2D:
	if animated_sprite:
		return animated_sprite
	elif static_sprite:
		return static_sprite
	return null

func clear_enagements() -> void:
	for engagement in engagements:
		engagement.engagements.erase(self)
	engagements.clear()

func set_eliminated() -> void:
	AnimationUtils.play_battle_animation_event(self, BattleGlobals.ASSETS.animation_death,
			AnimationUtils.create_context(null, self))
	is_eliminated = true
	clear_enagements()
	eliminated.emit(self)

func is_engaged() -> bool:
	return !engagements.is_empty()

func _calculate_attack_damage(direction: int) -> int:
	var damage = 1
	if direction == move_direction:
		damage += momentum_current
	return damage

func _add_engagement(actor: BattleActor) -> void:
	if !actor.is_eliminated:
		if !engagements.has(actor):
			engagements.append(actor)
		if !actor.engagements.has(self):
			actor.engagements.append(self)

func _perform_skill_animation(skill: BattleSkill, target: BattleActor, damage: int) -> void:
	var context = AnimationUtils.create_context(self, target)
	context.value = str(damage)
	await AnimationUtils.play_battle_animation_event(self, skill.animation,
		context)

func _process_move(delta: float) -> void:
	var distance_to_target = BattleGrid.cell_to_world(move_path[move_path_target_idx]) - position
	var step = move_speed * delta

	if distance_to_target.length() <= step:
		position = BattleGrid.cell_to_world(move_path[move_path_target_idx])
		move_path_target_idx += 1
		_update_move_direction()
	else:
		position += distance_to_target.normalized() * min(step, distance_to_target.length())

func _end_move() -> void:
	move_path.clear()
	move_path_target_idx = 0
	is_busy = false
	is_moving = false
	position_changed.emit(self)
	_set_sprite_direction(move_direction)
	_action_completed()

func _update_move_direction() -> void:
	if move_path_target_idx >= move_path.size():
		_end_move()
	else:
		var delta: Vector2i = move_path[move_path_target_idx] - get_current_cell()
		var new_move_direction = Direction.from_vector(Vector2i(sign(delta.x), sign(delta.y)))
		if move_direction != new_move_direction:
			momentum_current = 0
			move_direction = new_move_direction
			_set_sprite_direction(move_direction)
		else:
			momentum_current = min(momentum_current + 1, data.momentum_max)

func _set_sprite_direction(direction: int) -> void:
	var direction_string = Direction.to_str(direction)
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

func _action_completed(fire_event: bool = true) -> void:
	is_busy = false
	if fire_event:
		action_completed.emit(self)
