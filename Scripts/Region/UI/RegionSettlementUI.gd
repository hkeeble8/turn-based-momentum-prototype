class_name RegionSettlementUI
extends MarginContainer

@export var title_label: Label
@export var current_text_label: Label

func _ready() -> void:
	current_text_label.text = "Testing"

func init_ui(settlement: SettlementViewModel) -> void:
	title_label.text = settlement.name + " - Owner: " + str(settlement.owner_name)
	current_text_label.text = "Above the gates hangs a %s." % settlement.banner.banner_description
