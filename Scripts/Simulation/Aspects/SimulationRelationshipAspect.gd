class_name SimulationRelationshipAspect
extends SimulationAspect

func get_type() -> StringName:
	return SimulationAspectType.RELATIONSHIPS

var _entity_relationships: Dictionary[int, Array] = {}
var _relationships_entity: Dictionary[StringName, Array] = {}

func add(type: StringName, entity_id: int) -> void:
	_entity_relationships.get_or_add(entity_id, []).append(type)
	_relationships_entity.get_or_add(type, []).append(entity_id)

func add_all(type: StringName, entity_ids: Array[int]) -> void:
	for entity_id in entity_ids:
		add(type, entity_id)

func get_of_type(type: StringName) -> Array:
	return _relationships_entity.get(type, [])

func get_with_entity(entity_id: int) -> Array:
	return _entity_relationships.get(entity_id, [])

func serialize_data() -> Dictionary:
	return _relationships_entity

static func deserialize(data: Dictionary) -> SimulationRelationshipAspect:
	var aspect = SimulationRelationshipAspect.new()
	for relationship_type in data.keys():
		aspect.add_all(relationship_type, _to_int_array(data[relationship_type]))
	return aspect

static func _to_int_array(values: Array) -> Array[int]:
	var result: Array[int] = []
	for value in values:
		result.append(int(value))
	return result
