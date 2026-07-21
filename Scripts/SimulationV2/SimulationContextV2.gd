class_name SimulationContextV2
extends RefCounted

var day: int
var steps_today: int
var entities: Dictionary[int, SimulationEntityV2]

func _init(new_day: int, new_steps_today: int, new_entities: Dictionary[int, SimulationEntityV2]) -> void:
	day = new_day
	steps_today = new_steps_today
	entities = new_entities

func get_entities(aspect_types: Array[SimulationAspect.Type] = []) -> Array[SimulationEntityV2]:
	if aspect_types.is_empty():
		return entities.values()

	var matched_entities: Array[SimulationEntityV2] = []
	for entity in entities.values():
		if entity.aspects.has_all(aspect_types):
			matched_entities.append(entity)
	return matched_entities
