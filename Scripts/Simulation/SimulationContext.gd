class_name SimulationContext
extends RefCounted

var date_time: SimulationDateTime
var entities: Dictionary[int, SimulationEntity]
var contracts: Dictionary[int, Contract]

func _init(
		date_time: SimulationDateTime,
		entities: Dictionary[int, SimulationEntity],
		contracts: Dictionary[int, Contract]
	) -> void:
	self.date_time = date_time
	self.entities = entities
	self.contracts = contracts

func get_entities(aspect_types: Array[StringName] = []) -> Array[SimulationEntity]:
	if aspect_types.is_empty():
		return entities.values()

	var matched_entities: Array[SimulationEntity] = []
	for entity in entities.values():
		if entity.aspects.has_all(aspect_types):
			matched_entities.append(entity)
	return matched_entities
