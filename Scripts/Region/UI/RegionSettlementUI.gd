class_name RegionSettlementUI
extends Control

signal accept_contract_button_pressed(contract_id: int)
signal leave_button_pressed()

enum Mode {
	HOME,
	CONTRACTS
}

var mode_controls: Dictionary[Mode, Control]
var mode_initialisers: Dictionary[Mode, Callable]
var settlement: SettlementViewModel

@export var home_control: Control
@export var contracts_control: Control

@export var title_label: Label
@export var current_text_label: Label

@export var search_contracts_button: Button
@export var leave_button: Button
@export var home_button: Button

func _ready() -> void:
	mode_controls = {
		Mode.HOME: home_control,
		Mode.CONTRACTS: contracts_control,
	}
	mode_initialisers = {
		Mode.HOME: _init_home,
		Mode.CONTRACTS: _init_contracts,
	}

	set_mode(Mode.HOME)
	_init_connections()

func set_settlement(p_settlement: SettlementViewModel) -> void:
	settlement = p_settlement

func _init_home() -> void:
	if settlement != null:
		title_label.text = settlement.name + " of the " + str(settlement.owner_name)
		current_text_label.text = "Above the gates hangs a %s." % settlement.banner.banner_description
		current_text_label.text += "\n"
		for entity_id in settlement.memories.entity_seen_memories.keys():
			var memory = settlement.memories.entity_seen_memories[entity_id]
			current_text_label.text += memory
			current_text_label.text += "\n"

func _init_contracts() -> void:
	NodeUtils.free_nodes(contracts_control.get_children())
	if settlement != null:
		for contract in settlement.contracts:
			var ui_item: RegionContractItemUI = RegionGlobals.ASSETS.contract_item_ui.instantiate()
			ui_item.set_contract(contract)
			ui_item.contract_accepted.connect(_on_accept_contract_button_pressed)
			contracts_control.add_child(ui_item)

func _init_connections() -> void:
	home_button.pressed.connect(_on_home_button_pressed)
	search_contracts_button.pressed.connect(_on_search_contracts_button_pressed)
	leave_button.pressed.connect(_on_leave_button_pressed)

func _on_home_button_pressed() -> void:
	set_mode(Mode.HOME)

func _on_leave_button_pressed() -> void:
	leave_button_pressed.emit()

func _on_search_contracts_button_pressed() -> void:
	set_mode(Mode.CONTRACTS)

func _on_accept_contract_button_pressed(contract_id: int) -> void:
	accept_contract_button_pressed.emit(contract_id)

func set_mode(mode: Mode) -> void:
	for mode_key in mode_controls.keys():
		var control = mode_controls.get(mode_key)
		if mode_key == mode:
			control.show()
			mode_initialisers.get(mode_key).call()
		else:
			control.hide()
