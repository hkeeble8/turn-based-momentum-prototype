class_name SimulationMemoryAspect
extends SimulationAspect

signal learned_entity_location(entity_id: int, location: Vector2i)

@export var entity_last_seen: Dictionary[int, SimulationDateTime] = {}
@export var entity_last_known_location: Dictionary[int, Vector2i] = {}

func entity_seen(
    entity_id: int,
    date_time: SimulationDateTime,
    location: Vector2i
) -> void:
    entity_last_seen[entity_id] = date_time.duplicate()
    entity_last_known_location[entity_id] = location

func entity_location_learned(entity_id: int, location: Vector2i) -> void:
    entity_last_known_location[entity_id] = location
    learned_entity_location.emit(entity_id, location)

func get_entity_last_known_location(entity_id: int):
    return entity_last_known_location.get(entity_id)

func get_entity_last_seen(entity_id: int) -> SimulationDateTime:
    return entity_last_seen.get(entity_id)