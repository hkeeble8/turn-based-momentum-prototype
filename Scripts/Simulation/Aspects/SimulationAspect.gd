class_name SimulationAspect
extends RefCounted

enum Type {
	UNDEFINED,
	BRAIN,
	SETTLEMENT,
	LOCATION
}

func process_step() -> void:
    pass

func get_type() -> int:
    return Type.UNDEFINED