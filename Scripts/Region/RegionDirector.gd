class_name RegionDirector
extends Node

signal battle_requested

var is_paused: bool = false

var player_actor: RegionActor

var input_manager: RegionInputManager
var camera_manager: CameraManager
var pathfinder_manager: PathfinderManager
var simulation_manager: SimulationManager
var actor_manager: RegionActorManager
var ui_manager: RegionUIManager

var encounter_actors: Array[RegionActor]

var command_processors: Dictionary[int, CommandProcessor]

var pathfinder_delegate: PathfinderDelegate

func _init(
	new_input_manager: RegionInputManager,
	new_camera_manager: CameraManager,
	new_pathfinder_manager: PathfinderManager,
	new_simulation_manager: SimulationManager,
	new_actor_manager: RegionActorManager,
	new_ui_manager: RegionUIManager,
	new_command_processors: Dictionary[int, CommandProcessor],
):
	input_manager = new_input_manager
	camera_manager = new_camera_manager
	pathfinder_manager = new_pathfinder_manager
	simulation_manager = new_simulation_manager
	actor_manager = new_actor_manager
	ui_manager = new_ui_manager

	command_processors = new_command_processors

	_init_connections()
	_init_processor_connections()

func _init_connections() -> void:
	input_manager.map_pan_requested.connect(_on_map_pan_requested)
	input_manager.map_pan_stopped.connect(_on_map_pan_stopped)
	input_manager.interaction_at_location.connect(_on_interaction_at_location)

	simulation_manager.simulation_command_issued.connect(_on_simulation_command_issued)

	actor_manager.actor_position_changed.connect(_on_actor_position_changed)
	actor_manager.actor_collision.connect(_on_actor_collision)
	actor_manager.actor_became_available.connect(_on_actor_became_available)

	ui_manager.pause_requested.connect(_on_pause_requested)
	ui_manager.continue_requested.connect(_on_continue_requested)
	ui_manager.save_requested.connect(_on_save_requested)
	ui_manager.load_requested.connect(_on_load_requested)

	ui_manager.leave_requested.connect(_on_encounter_leave_requested)
	ui_manager.attack_requested.connect(_on_attack_requested)

func _init_processor_connections() -> void:
	command_processors[SimulationCommand.Type.MOVE].register(_on_move_command_processed)

func _on_map_pan_requested(direction: Vector2) -> void:
	camera_manager.request_manual_pan(direction)

func _on_map_pan_stopped() -> void:
	camera_manager.stop_manual_pan()

func _on_interaction_at_location(position: Vector2, _cell: Vector2i) -> void:
	_handle_interaction_at_location(position)

func _on_simulation_command_issued(command: SimulationCommand) -> void:
	_handle_simulation_command_issued(command)

func _on_move_command_processed(actor: RegionActor, cell: Vector2i) -> void:
	_handle_actor_move_request(actor, cell)

func _on_actor_position_changed(actor: RegionActor) -> void:
	_handle_actor_position_changed(actor)

func _on_actor_collision(actor: RegionActor, subject_actor: RegionActor) -> void:
	_handle_actor_collision(actor, subject_actor)

func _on_actor_became_available(actor: RegionActor) -> void:
	_handle_actor_became_available(actor)

func _on_pause_requested() -> void:
	_handle_pause_requested()

func _on_continue_requested() -> void:
	_handle_continue_requested()

func _on_save_requested() -> void:
	_handle_save_requested()

func _on_load_requested() -> void:
	_handle_load_requested()

func _on_encounter_leave_requested() -> void:
	_handle_encounter_leave_requested()

func _on_attack_requested() -> void:
	_handle_attack_requested()

func _handle_interaction_at_location(position: Vector2) -> void:
	if !is_paused:
		var selected_actor = actor_manager.select_actor_at(position)
		if selected_actor == null:
			_handle_actor_move_request(player_actor, RegionGrid.world_to_cell(position))
		else:
			_handle_actor_move_request(player_actor, RegionGrid.world_to_cell(selected_actor.position))
			actor_manager.add_follower(selected_actor, player_actor)

func _handle_actor_move_request(actor: RegionActor, cell: Vector2i) -> void:
	var cell_path: Array[Vector2i] = _actor_path_to_target(actor, cell)
	if cell_path.size() > 0 && cell_path.back() == cell:
		actor.move_on_path(cell_path)

func _handle_actor_collision(actor: RegionActor, subject_actor: RegionActor) -> void:
	if actor_manager.get_followers(actor).has(subject_actor):
		actor.stop_all()
		subject_actor.stop_all()
		actor_manager.get_followers(actor).erase(subject_actor)
		simulation_manager.reset_actor_states([actor, subject_actor])
		ui_manager.show_encounter_ui()
		encounter_actors = [actor, subject_actor]

func _handle_simulation_command_issued(command: SimulationCommand) -> void:
	var executor_actor = simulation_manager.entity_actor[command.executor_entity_id]
	if !executor_actor.is_busy:
		command_processors[command.get_type()].process(simulation_manager.entity_actor, command)
	else:
		executor_actor.queued_simulation_command = command

func _handle_actor_position_changed(actor: RegionActor) -> void:
	for follower in actor_manager.get_followers(actor):
		_handle_actor_move_request(follower, RegionGrid.world_to_cell(actor.position))
	simulation_manager.actor_position_changed(actor)

func _handle_actor_became_available(actor: RegionActor) -> void:
	if actor.queued_simulation_command != null:
		var command = actor.queued_simulation_command
		actor.queued_simulation_command = null
		_handle_simulation_command_issued(command)

func _handle_pause_requested() -> void:
	ui_manager.show_pause_ui()
	simulation_manager.pause()
	actor_manager.pause()
	is_paused = true

func _handle_continue_requested() -> void:
	ui_manager.show_default_ui()
	simulation_manager.play()
	actor_manager.play()
	is_paused = false

func _handle_save_requested() -> void:
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	var json = JSON.stringify(simulation_manager.get_save_state().serialize())
	file.store_string(json)
	file.close()

func _handle_load_requested() -> void:
	var file = FileAccess.open("user://savegame.json", FileAccess.READ)
	_clear_actors()
	_load(file.get_as_text())

func _handle_encounter_leave_requested() -> void:
	ui_manager.hide_encounter_ui()
	for actor in encounter_actors:
		actor.available()

func _handle_attack_requested() -> void:
	battle_requested.emit()

func _actor_path_to_target(actor: RegionActor, target: Vector2i) -> Array[Vector2i]:
	return _path_to_target(actor.get_current_cell(), target)

func _path_to_target(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	return pathfinder_manager.get_cell_path(start, end)

func _load(json: String) -> void:
	var save_state = SaveState.deserialize(json)
	

func _clear_actors() -> void:
	for actor in actor_manager.actors:
		actor.queue_free()
	actor_manager.clear()
	simulation_manager.clear()
