class_name SimulationAspectFactory

static func deserialize(type: SimulationAspect.Type, data: Dictionary) -> SimulationAspect:
	if type == SimulationAspect.Type.BRAIN:
		return SimulationBrainAspect.new(
			SimulationBrainRegistry.get_actor_brain(data["brain"])
		)
	return null
