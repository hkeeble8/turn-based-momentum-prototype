class_name SimulationSettlementAspect
extends SimulationAspect

var population: int = 0
var food: int = 0

func get_type() -> int:
	return Type.SETTLEMENT
