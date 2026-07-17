class_name SimulationBrainAspect
extends SimulationAspect

var brain: SimulationBrain

func think(entity: SimulationEntity, context: SimulationContext) -> SimulationCommand:
	return brain.think(entity, context)

func get_type() -> int:
	return Type.BRAIN

func serialize_data() -> Dictionary:
	return {
		"brain": brain.resource_path
	}
