class_name SimulationAspect
extends Resource

func step(_entity: SimulationEntity, _context: SimulationContext) -> SimulationCommand:
	return null

func process_step() -> void:
	pass

func get_type() -> StringName:
	return SimulationAspectType.UNDEFINED