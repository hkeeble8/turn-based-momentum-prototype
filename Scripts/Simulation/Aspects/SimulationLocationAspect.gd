class_name SimulationLocationAspect
extends SimulationAspect

var id: String
var name: String

func get_type() -> int:
	return Type.LOCATION

func serialize_data() -> Dictionary:
	return {
		"id": id,
		"name": name,
	}
