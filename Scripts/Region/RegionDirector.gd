class_name RegionDirector
extends Node

var current_actor: RegionActor

var input_manager: RegionInputManager
var camera_manager: CameraManager
var pathfinder_manager: PathfinderManager
var simulation_manager: SimulationManager

func _init(
	new_input_manager: RegionInputManager,
	new_camera_manager: CameraManager,
	new_pathfinder_manager: PathfinderManager,
	new_simulation_manager: SimulationManager
):
	input_manager = new_input_manager
	camera_manager = new_camera_manager
	pathfinder_manager = new_pathfinder_manager
	simulation_manager = new_simulation_manager

	_init_connections()

func _init_connections() -> void:
	input_manager.map_pan_requested.connect(_on_map_pan_requested)
	input_manager.map_pan_stopped.connect(_on_map_pan_stopped)
	input_manager.interaction_at_location.connect(_on_interaction_at_location)

func _on_map_pan_requested(direction: Vector2) -> void:
	camera_manager.request_manual_pan(direction)

func _on_map_pan_stopped() -> void:
	camera_manager.stop_manual_pan()

func _on_interaction_at_location(_position: Vector2, cell: Vector2i) -> void:
	_handle_interaction_at_location(cell)

func _handle_interaction_at_location(cell: Vector2i) -> void:
	_handle_actor_move_request(current_actor, cell)

func _handle_actor_move_request(actor: RegionActor, cell: Vector2i) -> void:
	camera_manager.set_target(current_actor)
	var cell_path: Array[Vector2i] = _current_actor_path_to_target(cell)
	if cell_path.size() > 0 && cell_path.back() == cell:
		actor.move_on_path(cell_path)

func _current_actor_path_to_target(target: Vector2i) -> Array[Vector2i]:
	return _path_to_target(current_actor.get_current_cell(), target)

func _path_to_target(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	return pathfinder_manager.get_cell_path(start, end)
