class_name SettlementAgentState
extends SimulationAgentState

@export var population: int = 0
@export var food: int = 0

func get_agent_type() -> int:
    return SimulationGlobals.AgentType.SETTLEMENT