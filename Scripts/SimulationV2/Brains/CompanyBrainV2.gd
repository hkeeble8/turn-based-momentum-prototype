class_name CompanyBrainV2
extends SimulationBrainV2

func think(entity: SimulationEntityV2, context: SimulationContextV2) -> SimulationCommandV2:
	if !entity.actor.is_moving:
		var settlements = context.get_entities([SimulationAspect.Type.SETTLEMENT])
		return SimulationMoveCommandV2.new(entity, settlements[0].position)
	return null
