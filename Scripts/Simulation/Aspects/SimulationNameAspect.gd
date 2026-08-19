class_name SimulationNameAspect
extends SimulationAspect

@export var name: String

func get_type() -> StringName:
	return SimulationAspectType.NAME
