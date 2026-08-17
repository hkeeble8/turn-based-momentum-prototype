class_name SimulationRelationshipAspect
extends SimulationAspect

enum RelationshipType {
	OWNED_BY,
	OWNER_OF
}

func get_type() -> StringName:
	return SimulationAspectType.RELATIONSHIPS

var relationships: Dictionary[RelationshipType, int] = {}

func serialize_data() -> Dictionary:
	return relationships

static func deserialize(data: Dictionary) -> SimulationRelationshipAspect:
	var aspect = SimulationRelationshipAspect.new()
	for key in data.keys():
		aspect.relationships[int(key)] = int(data[key])
	return aspect
