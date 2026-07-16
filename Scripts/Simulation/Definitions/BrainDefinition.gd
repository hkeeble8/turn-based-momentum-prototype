class_name BrainDefinition
extends SimulationEntityDefinition

@export var brain: SimulationBrain

func create_aspect() -> SimulationBrainAspect:
	var aspect = SimulationBrainAspect.new()
	aspect.brain = brain
	return aspect
