class_name SimulationManager
extends Node

var simulation: Simulation

func _init() -> void:
	_init_simulation()

func register_actor(actor: RegionActor) -> void:
	simulation.create_entity(actor.definitions)

func _init_simulation() -> void:
	simulation = Simulation.new()
