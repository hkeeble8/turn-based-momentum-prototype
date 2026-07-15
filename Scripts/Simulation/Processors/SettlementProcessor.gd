class_name SettlementProcessor

static func process_day_start(state: SettlementAgentState) -> void:
	state.food -= state.population

static func process(state: SettlementAgentState) -> void:
	pass
