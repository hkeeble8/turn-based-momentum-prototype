class_name SimulationRelationshipAspect
extends SimulationAspect

func get_type() -> StringName:
	return SimulationAspectType.RELATIONSHIPS

var relationships: Dictionary[StringName, int] = {}

func add(type: StringName, entity_id: int) -> void:
	relationships[type] = entity_id

func serialize_data() -> Dictionary:
	return relationships

static func deserialize(data: Dictionary) -> SimulationRelationshipAspect:
	var aspect = SimulationRelationshipAspect.new()
	for key in data.keys():
		aspect.relationships[key] = int(data[key])
	return aspect
