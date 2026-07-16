class_name SimulationCommand
extends RefCounted

enum Type {
    UNDEFINED,
	MOVE,
}

static var TYPE_NAMES := {
    Type.UNDEFINED: "undefined",
	Type.MOVE: "move",
}

static var TYPE_LOOKUP := {
    "undefined": Type.UNDEFINED,
	"move": Type.MOVE,
}

var day: int
var step: int
var source_entity_id: int

func _init(new_source_entity_id: int) -> void:
	source_entity_id = new_source_entity_id

func serialize() -> Dictionary:
	return {
		"type": TYPE_NAMES[get_type()],
		"day": day,
		"step": step,
		"source_entity_id": source_entity_id,
		"data": serialize_data()
	}

func serialize_data() -> Dictionary:
	return {}

func deserialize(data: Dictionary) -> void:
	pass

func get_type() -> int:
	return Type.UNDEFINED