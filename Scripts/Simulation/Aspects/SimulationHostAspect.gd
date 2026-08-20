class_name SimulationHostAspect
extends SimulationAspect

var members: Array[int] = []

func add(entity_id: int):
	members.append(entity_id)

func remove(entity_id: int):
	members.erase(entity_id)

func get_type() -> StringName:
	return SimulationAspectType.HOST