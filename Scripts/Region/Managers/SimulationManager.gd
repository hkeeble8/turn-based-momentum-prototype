class_name SimulationManager
extends Node

var simulation: Simulation
var step_timer: Timer

func _init() -> void:
	_init_simulation()

func register_actor(actor: RegionActor) -> void:
	simulation.create_entity(actor.name, actor.definitions)

func _init_simulation() -> void:
	simulation = Simulation.new()
	
	step_timer = Timer.new()
	step_timer.wait_time = 1
	step_timer.autostart = true
	step_timer.name = "StepTimer"
	step_timer.timeout.connect(_on_step_timer_timeout)
	add_child(step_timer)

func _on_step_timer_timeout() -> void:
	simulation.step()
