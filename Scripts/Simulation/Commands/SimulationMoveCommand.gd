class_name SimulationMoveCommand
extends SimulationCommand

var destination_entity_id: int

func serialize_data() -> Dictionary:
	return {
		"destination_entity_id": destination_entity_id
	}

func _init(new_executor_entity_id: int, new_destination_entity_id: int) -> void:
	super(new_executor_entity_id)
	destination_entity_id = new_destination_entity_id

func get_type() -> int:
	return Type.MOVE
