class_name CompanyBrain
extends SimulationBrain

func think(entity: SimulationEntity, context: SimulationContext) -> SimulationCommand:
	if entity.state != SimulationEntity.State.IDLE:
		return null
	var settlements = context.get_entities([SimulationAspect.Type.SETTLEMENT])
	return SimulationMoveCommand.new(entity.id, settlements[0].id)
