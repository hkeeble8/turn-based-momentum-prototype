class_name SimulationPlayerAspect
extends SimulationAspect

func step(_entity: SimulationEntity, _context: SimulationContext) -> SimulationCommand:
	return null

func get_type() -> StringName:
	return SimulationAspectType.PLAYER
