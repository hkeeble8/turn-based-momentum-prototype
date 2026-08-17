class_name SettlementViewModel
extends RefCounted

var id: int
var name: String
var owner_name: String

func _init(
	settlement_entity: SimulationEntity,
	context: SimulationContext
) -> void:
	var settlement_aspect: SimulationSettlementAspect = settlement_entity.aspects[SimulationAspectType.SETTLEMENT]
	var relationships_aspect: SimulationRelationshipAspect = settlement_entity.aspects[SimulationAspectType.RELATIONSHIPS]
	
	id = settlement_entity.id
	name = settlement_aspect.name
	
	var owner_entity = context.entities.get(relationships_aspect.relationships[SimulationRelationshipType.OWNED_BY])
	owner_name = owner_entity.name
