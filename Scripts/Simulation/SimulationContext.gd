class_name SimulationContext
extends RefCounted

var date_time: SimulationDateTime
var entities: Dictionary[int, SimulationEntity]
var contracts: Dictionary[int, Contract]

func _init(
		p_date_time: SimulationDateTime,
		p_entities: Dictionary[int, SimulationEntity],
		p_contracts: Dictionary[int, Contract]
	) -> void:
	date_time = p_date_time
	entities = p_entities
	contracts = p_contracts

func get_entities(aspect_types: Array[StringName] = []) -> Array[SimulationEntity]:
	if aspect_types.is_empty():
		return entities.values()

	var matched_entities: Array[SimulationEntity] = []
	for entity in entities.values():
		if entity.aspects.has_all(aspect_types):
			matched_entities.append(entity)
	return matched_entities
