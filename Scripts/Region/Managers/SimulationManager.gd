class_name SimulationManager
extends Node

var actor_agents: Dictionary[SimulationAgent, RegionActor]
var simulation: Simulation

func _init() -> void:
    _init_simulation()

func register_actor(actor: RegionActor) -> void:
    var agent = SimulationAgent.new(actor.starting_state)
    agent.name = actor.name.replace(" ", "") + "-" + "agent-" + str(actor.get_instance_id())
    simulation.register_agent(agent)

func _init_simulation() -> void:
    simulation = Simulation.new()
    simulation.name = "Simulation"
    add_child(simulation)