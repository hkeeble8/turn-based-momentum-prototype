class_name RegionDirector
extends Node

var simulation_manager: SimulationManager
var pathfinder_manager: PathfinderManager
var camera_manager: CameraManager
var input_manager: RegionInputManager

func _init(
	new_simulation_manager: SimulationManager,
	new_pathfinder_manager: PathfinderManager,
	new_camera_manager: CameraManager,
	new_input_manager: RegionInputManager,
) -> void:
	simulation_manager = new_simulation_manager
	pathfinder_manager = new_pathfinder_manager
	camera_manager = new_camera_manager
	input_manager = new_input_manager

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
	simulation_manager.move_player(cell)
