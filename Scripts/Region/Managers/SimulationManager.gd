class_name SimulationManager
extends Node

var simulation: Simulation
var step_timer: Timer
var entity_actor: Dictionary[int, RegionActor]
var actor_entity: Dictionary[RegionActor, int]

signal simulation_command_issued(command: SimulationCommand)

func _init() -> void:
	entity_actor = {}
	_init_simulation()

func register_actor(actor: RegionActor) -> void:
	var simulation_entity = simulation.add_entity(actor.name + " Entity", actor.definitions)
	entity_actor[simulation_entity.id] = actor
	actor_entity[actor] = simulation_entity.id
	add_child(simulation_entity)
	simulation_entity.command_issued.connect(_on_entity_command_issued)

func reset_actor_states(actors: Array[RegionActor]) -> void:
	for actor in actors:
		simulation.reset_entity_state(actor_entity.get(actor))

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