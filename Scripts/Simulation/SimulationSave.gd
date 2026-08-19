class_name SimulationSave
extends Resource

@export var next_entity_id: int
@export var date_time: SimulationDateTime
@export var entities: Dictionary[int, SimulationEntityData]

func _init(
	new_next_entity_id: int = 1,
	new_date_time: SimulationDateTime = SimulationDateTime.new(),
	new_entities: Dictionary[int, SimulationEntity] = {}
) -> void:
	next_entity_id = new_next_entity_id
	date_time = new_date_time
	entities = {}
	for entity_id in new_entities.keys():
		var entity = new_entities[entity_id]
		var entity_data = SimulationEntityData.new(
			entity.id,
			entity.position,
			entity.actor,
			entity.aspects,
			entity.hosted_by
		)
		entities[entity_id] = entity_data
