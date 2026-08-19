class_name SimulationAspectFactory

static func deserialize(type: StringName, data: Dictionary) -> SimulationAspect:
	if type == SimulationAspectType.BRAIN:
		return SimulationBrainAspect.new(
			SimulationBrainRegistry.get_actor_brain(data["brain"])
		)
	elif type == SimulationAspectType.SETTLEMENT:
		return SimulationSettlementAspect.deserialize(data)
	elif type == SimulationAspectType.RELATIONSHIPS:
		return SimulationRelationshipAspect.deserialize(data)
	elif type == SimulationAspectType.PLAYER:
		return SimulationPlayerAspect.new()
	elif type == SimulationAspectType.BANNER:
		return SimulationBannerAspect.new()
	elif type == SimulationAspectType.HOST:
		return SimulationHostAspect.new()
	elif type == SimulationAspectType.KNOWLEDGE:
		return SimulationKnowledgeAspect.deserialize(data)
	return null
