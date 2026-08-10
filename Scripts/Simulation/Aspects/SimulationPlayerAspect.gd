class_name SimulationPlayerAspect
extends SimulationAspect

func step(entity: SimulationEntity, context: SimulationContext) -> SimulationCommand:
	return null

func get_type() -> int:
	return Type.PLAYER
