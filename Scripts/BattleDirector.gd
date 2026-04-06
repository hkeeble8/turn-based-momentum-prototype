class_name BattleDirector
extends Node

var turn_manager: BattleTurnManager
var indicator_manager: BattleIndicatorManager
var ui_manager: BattleUIManager
var pathfinder_manager: BattlePathfinderManager
var input_manager: BattleInputManager
var actor_manager: BattleActorManager
var camera_manager: BattleCameraManager
var behaviour_manager: BattleBehaviourManager

var pathfinder_delegate: PathfinderDelegate

var battle_state: BattleState = BattleState.new()

var current_actor: BattleActor:
	get:
		return turn_manager.current_actor
var current_skill: BattleSkill

enum InputMode {
	MOVE,
	SKILL,
	DISABLED
}

var input_mode = InputMode.MOVE

func _init(
	new_turn_manager: BattleTurnManager,
	new_indicator_manager: BattleIndicatorManager,
	new_ui_manager: BattleUIManager,
	new_pathfinder_manager: BattlePathfinderManager,
	new_input_manager: BattleInputManager,
	new_actor_manager: BattleActorManager,
	new_camera_manager: BattleCameraManager,
	new_behaviour_manager: BattleBehaviourManager
):
	camera_manager = new_camera_manager
	turn_manager = new_turn_manager
	indicator_manager = new_indicator_manager
	ui_manager = new_ui_manager
	pathfinder_manager = new_pathfinder_manager
	input_manager = new_input_manager
	actor_manager = new_actor_manager
	behaviour_manager = new_behaviour_manager

	_init_delegates()
	_init_connections()

func _init_delegates() -> void:
	pathfinder_delegate = PathfinderDelegate.new(pathfinder_manager)

func _init_connections() -> void:
	turn_manager.turn_started.connect(_on_turn_started)
	
	input_manager.mouse_cell_changed.connect(_on_mouse_cell_changed)
	input_manager.mouse_over_ui.connect(_on_mouse_over_ui)
	input_manager.interaction_at_location.connect(_on_interaction_at_location)
	input_manager.end_turn_requested.connect(_on_end_turn_requested)
	input_manager.cancel_requested.connect(_on_cancel_requested)
	input_manager.map_pan_requested.connect(_on_map_pan_requested)
	input_manager.map_pan_stopped.connect(_on_map_pan_stopped)

	ui_manager.turn_end_requested.connect(_on_end_turn_requested)
	ui_manager.skill_selected.connect(_on_skill_selected)
	ui_manager.skill_deselected.connect(_on_skill_deselected)

	actor_manager.actor_position_changed.connect(_on_actor_position_changed)
	actor_manager.actor_eliminated.connect(_on_actor_eliminated)
	actor_manager.actor_action_completed.connect(_on_actor_action_completed)

	behaviour_manager.move_requested.connect(_on_actor_move_requested)
	behaviour_manager.end_turn_requested.connect(_on_end_turn_requested)
	behaviour_manager.use_skill_requested.connect(_on_use_skill_requested)

func _on_turn_started(actor: BattleActor) -> void:
	_handle_actor_phase_start(actor)

func _on_actor_position_changed(old_cell_position: Vector2i, new_cell_position: Vector2i) -> void:
	_handle_actor_position_changed(old_cell_position, new_cell_position)

func _on_actor_action_completed(actor: BattleActor) -> void:
	await get_tree().process_frame # Required to break stack loop on AI only
	_handle_actor_phase_start(actor)
	
func _on_actor_eliminated(actor: BattleActor) -> void:
	_handle_actor_eliminated(actor)

func _on_actor_move_requested(actor: BattleActor, cell: Vector2i) -> void:
	_handle_actor_move_request(actor, cell)

func _on_mouse_cell_changed(mouse_cell: Vector2i) -> void:
	_handle_update_mouse_cell(mouse_cell)

func _on_mouse_over_ui() -> void:
	_handle_mouse_over_ui()

func _on_interaction_at_location(_position: Vector2, cell: Vector2i) -> void:
	_handle_interaction_at_location(cell)

func _on_map_pan_requested(direction: Vector2) -> void:
	camera_manager.request_manual_pan(direction)

func _on_map_pan_stopped() -> void:
	camera_manager.stop_manual_pan()

func _on_end_turn_requested() -> void:
	if !_input_disabled() || !current_actor.is_player_controlled:
		await get_tree().process_frame # Required to break stack loop on AI only
		turn_manager.end_turn_requested()

func _on_cancel_requested() -> void:
	if input_mode != InputMode.MOVE:
		_handle_actor_phase_start(current_actor)

func _on_skill_selected(skill: BattleSkill) -> void:
	_handle_skill_selected(skill)

func _on_skill_deselected() -> void:
	_handle_skill_deselected()

func _on_use_skill_requested(skill: BattleSkill, source: BattleActor, target: BattleActor) -> void:
	_handle_actor_use_skill_request(skill, source, target)

func _handle_interaction_at_location(cell: Vector2i) -> void:
	if !_input_disabled() && !current_actor.is_busy:
		var actor_at_cell: BattleActor = actor_manager.actor_cell_positions.get(cell)
		match input_mode:
			InputMode.MOVE:
				_handle_actor_move_request(current_actor, cell)
			InputMode.SKILL:
				if actor_at_cell != null:
					_handle_actor_use_skill_request(current_skill, current_actor, actor_at_cell)

func _handle_action_start() -> void:
	indicator_manager.clear_path_indicators()
	indicator_manager.clear_cell_move_indicators()

func _handle_update_mouse_cell(mouse_cell: Vector2i) -> void:
	indicator_manager.clear_path_indicators()
	indicator_manager.move_cell_indicator(mouse_cell)
	if !_input_disabled():
		if !current_actor.is_busy:
			if input_mode == InputMode.SKILL:
				current_actor.set_facing(BattleGrid.direction(current_actor.get_current_cell(), mouse_cell))
			var cell_path: Array[Vector2i] = _current_actor_path_to_target(mouse_cell)
			if !cell_path.is_empty() && cell_path.back() == mouse_cell:
				indicator_manager.set_path_indicators(cell_path)

func _handle_mouse_over_ui() -> void:
	indicator_manager.clear_path_indicators()
	indicator_manager.hide_cell_select_indicator()

func _handle_actor_position_changed(old_cell_position: Vector2i, new_cell_position: Vector2i) -> void:
	if old_cell_position != null:
		pathfinder_manager.set_cell_solid(old_cell_position, false)
	if new_cell_position != null:
		pathfinder_manager.set_cell_solid(new_cell_position, true)

func _handle_actor_phase_start(actor: BattleActor) -> void:
	ui_manager.update_hud(actor)
	camera_manager.set_target(actor)
	var reachable_cells = pathfinder_manager.get_reachable_cells(actor.get_current_cell(),
		actor.movement_points_current)
	indicator_manager.init_for_turn(actor, reachable_cells)
	if actor.is_player_controlled:
		input_mode = InputMode.MOVE
		input_manager.update_mouse_cell()
	else:
		input_mode = InputMode.DISABLED
		_update_battle_state()
		behaviour_manager.decide_action(actor, battle_state, pathfinder_delegate)

func _handle_actor_eliminated(actor: BattleActor) -> void:
	pathfinder_manager.set_cell_solid(actor.get_current_cell(), false)
	turn_manager.unregister_actor(actor)

func _handle_actor_use_skill_request(skill: BattleSkill, actor: BattleActor, target: BattleActor) -> void:
	if BattleGrid.distance(actor.get_current_cell(), target.get_current_cell()) <= skill.maximum_range:
		camera_manager.set_target(target)
		actor.use_skill(skill, target)

func _handle_actor_move_request(actor: BattleActor, cell: Vector2i) -> void:
	camera_manager.set_target(current_actor)
	if actor.is_enaged:
		await _handle_engagement_break(actor)
	if actor.is_eliminated:
		_on_end_turn_requested()
	else:
		var cell_path: Array[Vector2i] = _current_actor_path_to_target(cell)
		if cell_path.size() > 0 && cell_path.back() == cell:
			_handle_action_start()
			actor.move_on_path(cell_path)

func _handle_skill_selected(skill: BattleSkill) -> void:
	if current_actor.action_points_current > 0:
		var reachable_cells = pathfinder_manager.get_reachable_cells(current_actor.get_current_cell(), skill.maximum_range)
		indicator_manager.set_cell_attack_indicators(reachable_cells)
		indicator_manager.clear_cell_move_indicators()
		current_skill = skill
		input_mode = InputMode.SKILL

func _handle_skill_deselected() -> void:
	indicator_manager.clear_cell_attack_indicators()
	var reachable_cells = pathfinder_manager.get_reachable_cells(current_actor.get_current_cell(), current_actor.movement_points_current)
	indicator_manager.set_cell_move_indicators(reachable_cells)
	current_skill = null
	input_mode = InputMode.MOVE

func _handle_engagement_break(actor: BattleActor) -> void:
	for enagement in actor.engagements:
		await enagement.use_skill(enagement.skills[0], actor, false)
	actor.clear_enagements()

func _current_actor_path_to_target(target: Vector2i) -> Array[Vector2i]:
	return _path_to_target(
		current_actor.get_current_cell(),
		target,
		current_actor.movement_points_current
	)

func _path_to_target(start: Vector2i, end: Vector2i, limit: int = 0) -> Array[Vector2i]:
	var cell_path = pathfinder_manager.get_cell_path(start, end)
	cell_path.resize(mini(cell_path.size(), limit))
	return cell_path

func _input_disabled() -> bool:
	return input_mode == InputMode.DISABLED

func _update_battle_state() -> void:
	battle_state.actors = actor_manager.cell_positions_actors.keys()
