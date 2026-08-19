class_name RegionSettlementUI
extends MarginContainer

signal leave_button_pressed()

@export var title_label: Label
@export var current_text_label: Label

@export var leave_button: Button

func _ready() -> void:
	current_text_label.text = "Testing"
	_init_connections()

func init_ui(settlement: SettlementViewModel) -> void:
	title_label.text = settlement.name + " - Owner: " + str(settlement.owner_name)
	current_text_label.text = "Above the gates hangs a %s." % settlement.banner.banner_description
	current_text_label.text += "\n"
	for knowledge in settlement.knowledge.knowledges:
		current_text_label.text += knowledge
		current_text_label.text += "\n"

func _init_connections() -> void:
	leave_button.pressed.connect(_on_leave_button_pressed)

func _on_leave_button_pressed() -> void:
	leave_button_pressed.emit()
