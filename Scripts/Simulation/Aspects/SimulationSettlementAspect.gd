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

func step(_entity: SimulationEntity, _context: SimulationContext) -> SimulationCommand:
	return null

func get_type() -> StringName:
	return SimulationAspectType.SETTLEMENT
