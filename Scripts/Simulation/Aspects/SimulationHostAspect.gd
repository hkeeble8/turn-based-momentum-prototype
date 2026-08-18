class_name SimulationHostAspect
extends SimulationAspect

var members: Array[int] = []

func add(entity_id: int):
	members.append(entity_id)

func remove(entity_id: int):
	members.erase(entity_id)

func get_type() -> StringName:
	return SimulationAspectType.HOST

func serialize_data() -> Dictionary:
	return {
		"members": members
	}

static func deserialize(data: Dictionary) -> SimulationHostAspect:
	var aspect = SimulationHostAspect.new()
	aspect.members = data["members"]
	return aspect
