class_name SimulationBrainAspect
extends SimulationAspect

@export var brain: SimulationBrain

func _init(new_brain: SimulationBrain = null) -> void:
	brain = new_brain

func step(entity: SimulationEntity, context: SimulationContext) -> SimulationCommand:
	return brain.think(entity, context)

func get_type() -> int:
	return Type.BRAIN

func serialize_data() -> Dictionary:
	return {
		"brain": brain.id
	}
