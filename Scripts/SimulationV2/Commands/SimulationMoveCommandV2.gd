class_name SimulationMoveCommandV2
extends SimulationCommandV2

var position: Vector2i

func _init(new_executor_entity: SimulationEntityV2, new_position: Vector2i) -> void:
	super(new_executor_entity)
	position = new_position

func get_type() -> int:
	return SimulationCommand.Type.MOVE