class_name SimulationSettlementAspect
extends SimulationAspect

@export var population: int = 0
@export var food: int = 0

func get_type() -> int:
	return Type.SETTLEMENT

func serialize_data() -> Dictionary:
	return {
		"population": population,
		"food": food,
	}
