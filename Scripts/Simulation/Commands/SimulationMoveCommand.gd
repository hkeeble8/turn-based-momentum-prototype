class_name SimulationMoveCommand
extends SimulationCommand

var target_entity_id: int

func serialize_data() -> Dictionary:
	return {
		"target_entity_id": target_entity_id
	}

func _init(new_source_entity_id: int, new_target_entity_id: int) -> void:
	super(source_entity_id)
	target_entity_id = new_source_entity_id

func get_type() -> int:
	return Type.MOVE