class_name SimulationEntityFactory

static func deserialize(data: Dictionary) -> SimulationEntity:
	var entity = SimulationEntity.new()
	entity.id = data["id"]
	entity.name = data["name"]
	entity.hosted_by = data["hosted_by"]

	entity.position = Vector2i(
		data["position"]["x"],
		data["position"]["y"]
	)
	
	for aspect_key in data["aspects"].keys():
		var aspect = SimulationAspectFactory.deserialize(
			aspect_key as StringName,
			data["aspects"][aspect_key]["data"]
		)
		if aspect != null:
			entity.aspects[aspect_key] = aspect
		else:
			push_warning("Aspect key %s could not be deserialised into an aspect, ignoring."
			 % aspect_key)
	
	if data.has("actor"):
		entity.actor = SimulationActor.deserialize(data["actor"])
		entity.actor.position = RegionGrid.cell_to_world(entity.position)
		entity.add_child(entity.actor)
	return entity
