class_name CompanyBrain
extends SimulationBrain

func think(entity: SimulationEntity, context: SimulationContext) -> SimulationCommand:
	if !entity.actor.is_moving:
		var settlements = context.get_entities([SimulationAspectType.SETTLEMENT])
		if !settlements.is_empty():
			return SimulationMoveCommand.new(entity, settlements[0].position)
	return null
