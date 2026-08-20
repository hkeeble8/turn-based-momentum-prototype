class_name SimulationCommand
extends RefCounted

enum Type {
    UNDEFINED,
	MOVE,
    STOP_ALL,
    LEAVE_HOST,
    ACCEPT_CONTRACT
}

var executor_entity: SimulationEntity

func _init(new_executor_entity: SimulationEntity) -> void:
    executor_entity = new_executor_entity

func get_type() -> int:
    return Type.UNDEFINED