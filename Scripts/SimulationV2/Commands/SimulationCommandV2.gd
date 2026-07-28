class_name SimulationCommandV2
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

var executor_entity: SimulationEntityV2

func _init(new_executor_entity: SimulationEntityV2) -> void:
    executor_entity = new_executor_entity

func get_type() -> int:
    return Type.UNDEFINED