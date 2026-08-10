class_name SimulationAspect
extends Resource

enum Type {
	UNDEFINED,
	BRAIN,
	SETTLEMENT,
	PLAYER
}

func step(_entity: SimulationEntity, _context: SimulationContext) -> SimulationCommand:
	return null

func process_step() -> void:
	pass

func get_type() -> int:
	return Type.UNDEFINED

func serialize() -> Dictionary:
	return {
		"data": serialize_data()
	}

func serialize_data() -> Dictionary:
	return {}

func deserialize(_data: Dictionary) -> void:
	pass
