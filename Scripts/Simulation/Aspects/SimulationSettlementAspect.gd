class_name SimulationSettlementAspect
extends SimulationAspect

@export var name: String

func step(entity: SimulationEntity, context: SimulationContext) -> SimulationCommand:
	return null

func get_type() -> int:
	return Type.SETTLEMENT

func serialize_data() -> Dictionary:
	return {
		"name": name
	}

static func deserialize(data: Dictionary) -> SimulationSettlementAspect:
	var aspect = SimulationSettlementAspect.new()
	aspect.name = data["name"]
	return aspect
