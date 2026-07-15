class_name SimulationGlobals

enum AgentType {
	UNDEFINED,
	SETTLEMENT
}

static var CONFIG: SimulationConfig

static var AGENT_DEFINITIONS: Dictionary[AgentType, SimulationAgentDefinition] = {
	AgentType.UNDEFINED: SimulationAgentDefinition.new(null, null),
	AgentType.SETTLEMENT: SimulationAgentDefinition.new(SettlementBrain, SettlementProcessor),
}
