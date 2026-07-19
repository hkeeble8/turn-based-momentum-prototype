class_name SimulationManager
extends Node

var simulation: Simulation
var step_timer: Timer
var actors: Dictionary[int, RegionActor]

signal simulation_command_issued(command: SimulationCommand)

func _init() -> void:
	actors = {}
	_init_simulation()

func register_actor(actor: RegionActor) -> void:
	var simulation_entity = simulation.add_entity(actor.name + " Entity", actor.definitions)
	actors[simulation_entity.id] = actor
	add_child(simulation_entity)
	simulation_entity.command_issued.connect(_on_entity_command_issued)

func _init_simulation() -> void:
	simulation = Simulation.new()
	
	step_timer = Timer.new()
	step_timer.wait_time = 0.5
	step_timer.autostart = true
	step_timer.name = "StepTimer"
	step_timer.timeout.connect(_on_step_timer_timeout)
	add_child(step_timer)

func _on_step_timer_timeout() -> void:
	simulation.step()

func _on_entity_command_issued(command: SimulationCommand) -> void:
	simulation_command_issued.emit(command)