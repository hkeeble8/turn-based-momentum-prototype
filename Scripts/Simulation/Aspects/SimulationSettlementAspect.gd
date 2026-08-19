class_name SimulationSettlementAspect
extends SimulationAspect

enum Structure {
	TAVERN = 0,
	MARKET = 1,
	PORT = 2,
	STABLES = 3,
	PALACE = 4,
}

const RELATIONSHIP_STRINGS := {
	Structure.TAVERN: "tavern",
	Structure.MARKET: "market",
	Structure.PORT: "port",
	Structure.STABLES: "stables",
	Structure.PALACE: "palace",
}

@export var name: String
@export var structures: Array[Structure]

func step(entity: SimulationEntity, context: SimulationContext) -> SimulationCommand:
	return null

func get_type() -> StringName:
	return SimulationAspectType.SETTLEMENT

func serialize_data() -> Dictionary:
	return {
		"name": name,
		"structures": structures
	}

static func deserialize(data: Dictionary) -> SimulationSettlementAspect:
	var aspect = SimulationSettlementAspect.new()
	aspect.name = data["name"]
	return aspect
