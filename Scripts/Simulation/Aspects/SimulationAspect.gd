class_name SimulationAspect
extends RefCounted

enum Type {
	UNDEFINED,
	BRAIN,
	SETTLEMENT,
}

static var TYPE_NAMES := {
	Type.UNDEFINED: "undefined",
	Type.BRAIN: "brain",
	Type.SETTLEMENT: "settlement",
}

static var TYPE_LOOKUP := {
	"undefined": Type.UNDEFINED,
	"brain": Type.BRAIN,
	"settlement": Type.SETTLEMENT,
}

func process_step() -> void:
	pass

func get_type() -> int:
	return Type.UNDEFINED

func serialize() -> Dictionary:
	return {
		"type": TYPE_NAMES[get_type()],
		"data": serialize_data()
	}

func serialize_data() -> Dictionary:
	return {}

func deserialize(data: Dictionary) -> void:
	pass
