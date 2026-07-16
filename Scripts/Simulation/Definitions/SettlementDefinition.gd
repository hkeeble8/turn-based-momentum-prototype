class_name SettlementDefinition
extends SimulationEntityDefinition

@export var population: int = 0
@export var food: int = 0

func create_aspect() -> SimulationSettlementAspect:
	var aspect = SimulationSettlementAspect.new()
	aspect.population = population
	aspect.food = food
	return aspect
