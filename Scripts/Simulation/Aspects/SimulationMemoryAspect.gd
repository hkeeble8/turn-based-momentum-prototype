class_name SimulationMemoryAspect
extends SimulationAspect

@export var entity_last_seen: Dictionary[int, SimulationDateTime] = {}

func entity_seen(entity_id: int, date_time: SimulationDateTime) -> void:
    entity_last_seen[entity_id] = date_time.duplicate()

func get_entity_last_seen(entity_id: int) -> SimulationDateTime:
    return entity_last_seen.get(entity_id)