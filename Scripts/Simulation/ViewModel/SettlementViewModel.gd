class_name SettlementViewModel
extends RefCounted

var id: int
var name: String
var owner_name: String
var banner: BannerViewModel
var structures: Array[String]

func _init(
	settlement_entity: SimulationEntity,
	context: SimulationContext
) -> void:
	var settlement_aspect: SimulationSettlementAspect = settlement_entity.aspects[SimulationAspectType.SETTLEMENT]
	var relationships_aspect: SimulationRelationshipAspect = settlement_entity.aspects[SimulationAspectType.RELATIONSHIPS]
	
	id = settlement_entity.id
	name = settlement_aspect.name

	var owner_entity_ids = relationships_aspect.get_of_type(SimulationRelationshipType.OWNED_BY)
	if !owner_entity_ids.is_empty():
		var owner_entity = context.entities.get(owner_entity_ids[0])
		owner_name = owner_entity.name
		banner = BannerViewModel.new(owner_entity, context)
