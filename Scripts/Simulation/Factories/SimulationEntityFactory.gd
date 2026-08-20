class_name SimulationEntityFactory

static func load(data: SimulationEntityData) -> SimulationEntity:
	var entity = SimulationEntity.new()
	entity.id = data.id
	entity.hosted_by = data.hosted_by
	entity.position = data.position
	entity.aspects = data.aspects
	
	var name_aspect = entity.aspects.get(SimulationAspectType.NAME)
	if name_aspect != null:
		entity.name = name_aspect.name

	if data.actor_id != null and !data.actor_id.is_empty():
		entity.actor = SimulationActorRegistry.get_actor_scene(data.actor_id).instantiate()
		entity.actor.position = RegionGrid.cell_to_world(entity.position)
		entity.add_child(entity.actor)
	return entity
