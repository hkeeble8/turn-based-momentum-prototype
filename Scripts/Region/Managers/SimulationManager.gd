class_name SimulationManager
extends Node

var simulation: Simulation

func _init() -> void:
    _init_simulation()

func _init_simulation() -> void:
    simulation = Simulation.new()
    simulation.name = "Simulation"
    add_child(simulation)