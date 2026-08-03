class_name SimulationMoveCommand
extends SimulationCommand

var position: Vector2i

func _init(new_executor_entity: SimulationEntity, new_position: Vector2i) -> void:
	super(new_executor_entity)
	position = new_position

func get_type() -> int:
	return SimulationCommand.Type.MOVE
