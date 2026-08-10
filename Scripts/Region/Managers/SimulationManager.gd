class_name SimulationManager
extends Node

var simulation: Simulation
var selected_player_entity: SimulationEntity
var step_timer: Timer

func _init(new_simulation: Simulation) -> void:
	simulation = new_simulation
	_init_simulation()
	if !simulation.player_entities.is_empty():
		selected_player_entity = simulation.player_entities[0]

func move_player(position: Vector2i) -> void:
	simulation.process_command(SimulationMoveCommand.new(selected_player_entity, position))

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

func _on_step_timer_timeout() -> void:
	simulation.step()
