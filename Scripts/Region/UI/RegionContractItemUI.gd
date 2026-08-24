class_name RegionContractItemUI
extends PanelContainer

signal contract_accepted(contract_id: int)

var contract: ContractViewModel

@export var description_label: Label
@export var reward_label: Label
@export var accept_button: Button

func set_contract(p_contract: ContractViewModel) -> void:
	contract = p_contract
	description_label.text = contract.description
	reward_label.text = "Reward Here"

func _ready() -> void:
	accept_button.pressed.connect(_on_accept_button_pressed)

func _on_accept_button_pressed() -> void:
	contract_accepted.emit(contract.id)
	self.queue_free()
