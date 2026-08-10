class_name RegionDirector
extends Node

var pathfinder_manager: PathfinderManager
var camera_manager: CameraManager
var input_manager: RegionInputManager

func _init(
	new_pathfinder_manager: PathfinderManager,
	new_camera_manager: CameraManager,
	new_input_manager: RegionInputManager,
) -> void:
	pathfinder_manager = new_pathfinder_manager
	camera_manager = new_camera_manager
	input_manager = new_input_manager

	_init_connections()

func _init_connections() -> void:
	input_manager.map_pan_requested.connect(_on_map_pan_requested)
	input_manager.map_pan_stopped.connect(_on_map_pan_stopped)

func _on_map_pan_requested(direction: Vector2) -> void:
	camera_manager.request_manual_pan(direction)

func _on_map_pan_stopped() -> void:
	camera_manager.stop_manual_pan()
