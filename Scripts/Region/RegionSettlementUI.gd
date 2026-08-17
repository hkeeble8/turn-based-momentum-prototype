class_name RegionSettlementUI
extends MarginContainer

@export var title_label: Label
@export var current_text_label: Label

func _ready() -> void:
	current_text_label.text = "Testing"

func init_ui(settlement: SimulationEntity) -> void:
	var settlement_aspect = settlement.aspects[SimulationAspectType.SETTLEMENT]

	var settlement_relationships = settlement.aspects[SimulationAspectType.RELATIONSHIPS]
	var owner_id = settlement_relationships.relationships[SimulationRelationshipType.OWNED_BY]

	title_label.text = settlement_aspect.name + " - Owner ID: " + str(owner_id)
