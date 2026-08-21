class_name SimulationAcceptContractCommand
extends SimulationCommand

var contract_id: int

func _init(p_executor_entity: SimulationEntity, p_contract_id: int) -> void:
	super(p_executor_entity)
	contract_id = p_contract_id

func get_type() -> int:
	return SimulationCommand.Type.ACCEPT_CONTRACT
