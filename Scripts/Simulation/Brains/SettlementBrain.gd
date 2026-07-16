class_name SettlementBrain
extends SimulationBrain

func think(entity: SimulationEntity, context: SimulationContext) -> Array[SimulationCommand]:
	var other_settlements = context.get_entities([
		SimulationAspect.Type.SETTLEMENT,
		SimulationAspect.Type.LOCATION
	]).filter(func(e):
		return e.id != entity.id
	)

	return [SimulationMoveCommand.new(entity.id, other_settlements[0].id)]
