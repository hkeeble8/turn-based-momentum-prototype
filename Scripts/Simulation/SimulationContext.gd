class_name SimulationContext
extends RefCounted

var date_time: SimulationDateTime
var entities: Dictionary[int, SimulationEntity]

func _init(new_date_time: SimulationDateTime, new_entities: Dictionary[int, SimulationEntity]) -> void:
	date_time = new_date_time
	entities = new_entities

func get_entities(aspect_types: Array[StringName] = []) -> Array[SimulationEntity]:
	if aspect_types.is_empty():
		return entities.values()

	var matched_entities: Array[SimulationEntity] = []
	for entity in entities.values():
		if entity.aspects.has_all(aspect_types):
			matched_entities.append(entity)
	return matched_entities
