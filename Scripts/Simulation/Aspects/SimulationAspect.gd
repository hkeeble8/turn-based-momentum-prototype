class_name SimulationAspect
extends Resource

enum Type {
	UNDEFINED = 0,
	BRAIN = 1,
	SETTLEMENT = 2,
	PLAYER = 3,
	RELATIONSHIPS = 4
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