class_name RegionDirector
extends Node

var simulation_manager: SimulationManager
var pathfinder_manager: PathfinderManager
var camera_manager: CameraManager
var input_manager: RegionInputManager
var ui_manager: RegionUIManager

func _init(
	new_simulation_manager: SimulationManager,
	new_pathfinder_manager: PathfinderManager,
	new_camera_manager: CameraManager,
	new_input_manager: RegionInputManager,
	new_ui_manager: RegionUIManager,
) -> void:
	simulation_manager = new_simulation_manager
	pathfinder_manager = new_pathfinder_manager
	camera_manager = new_camera_manager
	input_manager = new_input_manager
	ui_manager = new_ui_manager

	_init_connections()

func _init_connections() -> void:
	input_manager.map_pan_requested.connect(_on_map_pan_requested)
	input_manager.map_pan_stopped.connect(_on_map_pan_stopped)
	input_manager.interaction_at_location.connect(_on_interaction_at_location)
	input_manager.interaction_with_entity.connect(_on_interaction_with_entity)

	simulation_manager.player_entered_settlement.connect(_on_player_entered_settlement)

	ui_manager.accept_contract_requested.connect(_on_accept_contract_requested)
	ui_manager.pause_requested.connect(_on_pause_requested)
	ui_manager.leave_requested.connect(_on_ui_leave_requested)

func _on_map_pan_requested(direction: Vector2) -> void:
	camera_manager.request_manual_pan(direction)

func _on_map_pan_stopped() -> void:
	camera_manager.stop_manual_pan()

func _on_interaction_at_location(_position: Vector2, cell: Vector2i) -> void:
	simulation_manager.move_player(cell)

func _on_interaction_with_entity(entity_id: int) -> void:
	simulation_manager.move_player_to_entity(entity_id)

func _on_player_entered_settlement(settlement: SettlementViewModel) -> void:
	ui_manager.set_settlement(settlement)

func _on_accept_contract_requested(contract_id: int) -> void:
	simulation_manager.player_accept_contract(contract_id)

func _on_pause_requested() -> void:
	ui_manager.set_mode(RegionUI.Mode.PAUSE)
	simulation_manager.pause()

func _on_ui_leave_requested() -> void:
	ui_manager.set_mode(RegionUI.Mode.DEFAULT)
	simulation_manager.player_leave_host()
