class_name SimulationManager
extends Node

signal player_entered_settlement(settlement: SimulationSettlementAspect)

var simulation: Simulation
var selected_player_entity: SimulationEntity
var step_timer: Timer

func _init(new_simulation: Simulation) -> void:
	simulation = new_simulation
	_init_simulation()
	if !simulation.player_entities.is_empty():
		selected_player_entity = simulation.player_entities.values()[0]
	_init_connections()

func move_player(position: Vector2i) -> void:
	simulation.process_command(SimulationMoveCommand.new(selected_player_entity, position))

func move_player_to_entity(entity_id: int) -> void:
	simulation.process_command(SimulationMoveCommand.new(
		selected_player_entity, simulation.entities[entity_id].position
	))
	
func play() -> void:
	step_timer.start()

func pause() -> void:
	step_timer.stop()

func _init_simulation() -> void:
	step_timer = Timer.new()
	step_timer.wait_time = 0.5
	step_timer.autostart = true
	step_timer.name = "StepTimer"
	step_timer.timeout.connect(_on_step_timer_timeout)
	add_child(step_timer)

func _init_connections() -> void:
	simulation.player_entered_settlement.connect(_on_player_entered_settlement)

func _on_step_timer_timeout() -> void:
	simulation.step()

func _on_player_entered_settlement(settlement: SimulationSettlementAspect) -> void:
	player_entered_settlement.emit(settlement)
