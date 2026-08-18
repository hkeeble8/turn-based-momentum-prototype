class_name SimulationStopAllCommand
extends SimulationCommand

func _init(new_executor_entity: SimulationEntity) -> void:
	super(new_executor_entity)

func get_type() -> int:
	return SimulationCommand.Type.STOP_ALL
