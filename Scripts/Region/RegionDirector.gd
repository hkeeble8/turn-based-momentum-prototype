class_name RegionDirector
extends Node

var player_actor: RegionActor

var input_manager: RegionInputManager
var camera_manager: CameraManager
var pathfinder_manager: PathfinderManager
var simulation_manager: SimulationManager
var actor_manager: RegionActorManager

var command_processors: Dictionary[int, CommandProcessor]

var pathfinder_delegate: PathfinderDelegate

func _init(
	new_input_manager: RegionInputManager,
	new_camera_manager: CameraManager,
	new_pathfinder_manager: PathfinderManager,
	new_simulation_manager: SimulationManager,
	new_actor_manager: RegionActorManager,
	new_command_processors: Dictionary[int, CommandProcessor],
):
	input_manager = new_input_manager
	camera_manager = new_camera_manager
	pathfinder_manager = new_pathfinder_manager
	simulation_manager = new_simulation_manager
	actor_manager = new_actor_manager

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

func _handle_interaction_at_location(position: Vector2) -> void:
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

func _handle_simulation_command_issued(command: SimulationCommand) -> void:
	var executor_actor = simulation_manager.entity_actor[command.executor_entity_id]
	if !executor_actor.is_busy:
		command_processors[command.get_type()].process(simulation_manager.entity_actor, command)
	else:
		executor_actor.queued_simulation_command = command

func _handle_actor_position_changed(actor: RegionActor) -> void:
	for follower in actor_manager.get_followers(actor):
		_handle_actor_move_request(follower, RegionGrid.world_to_cell(actor.position))

func _handle_actor_became_available(actor: RegionActor) -> void:
	if actor.queued_simulation_command != null:
		var command = actor.queued_simulation_command
		actor.queued_simulation_command = null
		_handle_simulation_command_issued(command)

func _actor_path_to_target(actor: RegionActor, target: Vector2i) -> Array[Vector2i]:
	return _path_to_target(actor.get_current_cell(), target)

func _path_to_target(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	return pathfinder_manager.get_cell_path(start, end)
