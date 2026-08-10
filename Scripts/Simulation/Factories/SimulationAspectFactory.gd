class_name SimulationAspectFactory

static func deserialize(type: SimulationAspect.Type, data: Dictionary) -> SimulationAspect:
	if type == SimulationAspect.Type.BRAIN:
		return SimulationBrainAspect.new(
			SimulationBrainRegistry.get_actor_brain(data["brain"])
		)
	elif type == SimulationAspect.Type.SETTLEMENT:
		return SimulationSettlementAspect.new()
	elif type == SimulationAspect.Type.PLAYER:
		return SimulationPlayerAspect.new()
	return null
