class_name SimulationBrainAspectV2
extends SimulationAspect

@export var brain: SimulationBrainV2

func step(entity: SimulationEntityV2, context: SimulationContextV2) -> SimulationCommandV2:
	return brain.think(entity, context)

func get_type() -> int:
	return Type.BRAIN

func serialize_data() -> Dictionary:
	return {
		"brain": brain.resource_path
	}
