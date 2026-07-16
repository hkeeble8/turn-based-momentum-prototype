class_name SimulationEntity
extends RefCounted

var id: int
var name: String
var aspects: Dictionary[int, SimulationAspect] = {}

func _init(new_id: int, new_name: String, new_aspects: Array[SimulationAspect]) -> void:
	id = new_id
	name = new_name
	for aspect in new_aspects:
		aspects[aspect.get_type()] = aspect

func serialize() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"aspects": aspects.values().map(func(aspect): return aspect.serialize())
	}

func get_aspect(type: int) -> SimulationAspect:
	return aspects.get(type)

func process_step() -> void:
	pass
