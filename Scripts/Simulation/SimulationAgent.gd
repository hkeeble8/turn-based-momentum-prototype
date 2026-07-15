class_name SimulationAgent
extends Node

var state: SimulationAgentState
var brain
var processor

func _init(starting_state: SimulationAgentState) -> void:
	state = starting_state
	_init_brain_and_processor(starting_state.get_agent_type())

func _init_brain_and_processor(agent_type: SimulationGlobals.AgentType) -> void:
	var definition = SimulationGlobals.AGENT_DEFINITIONS[agent_type]
	brain = definition.brain
	processor = definition.processor

func process_step(day_start: bool) -> void:
	if processor != null:
		if day_start:
			processor.process_day_start(state)
		processor.process(state)
	if brain != null:
		brain.think(state)
