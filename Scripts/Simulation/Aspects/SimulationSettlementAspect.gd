class_name SimulationSettlementAspect
extends SimulationAspect

var population: int = 0
var food: int = 0

func get_type() -> int:
	return Type.SETTLEMENT

func serialize_data() -> Dictionary:
	return {
		"population": population,
		"food": food,
	}
