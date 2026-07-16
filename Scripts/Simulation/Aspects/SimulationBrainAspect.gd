class_name SimulationBrainAspect
extends SimulationAspect

var brain: SimulationBrain

func think(entity: SimulationEntity) -> Array:
	brain.think()
	return []

func get_type() -> int:
	return Type.BRAIN

func serialize_data() -> Dictionary:
	return {
		"brain": brain.resource_path
	}
