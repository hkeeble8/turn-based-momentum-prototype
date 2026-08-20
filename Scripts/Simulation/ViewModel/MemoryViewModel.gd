class_name MemoryViewModel
extends RefCounted

var entity_seen_memories: Dictionary[int, String]

func _init(
	entity: SimulationEntity,
	context: SimulationContext
) -> void:
	entity_seen_memories = {}
	var memory_aspect: SimulationMemoryAspect = entity.aspects.get(SimulationAspectType.MEMORY)
	for entity_id in memory_aspect.entity_last_seen.keys():
		var entity_last_seen_date_time = memory_aspect.get_entity_last_seen(entity_id)
		if context.date_time.day - entity_last_seen_date_time.day == 0:
			entity_seen_memories[entity_id] = "%s were seen here today." % context.entities.get(entity_id).name
		else:
			entity_seen_memories[entity_id] = "%s were seen here %s days ago." % [context.entities.get(entity_id).name, context.date_time.day - entity_last_seen_date_time.day]