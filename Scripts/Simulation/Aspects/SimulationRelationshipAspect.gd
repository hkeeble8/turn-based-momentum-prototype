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
