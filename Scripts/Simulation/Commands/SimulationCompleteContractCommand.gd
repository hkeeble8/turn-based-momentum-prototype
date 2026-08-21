class_name SimulationCompleteContractCommand
extends SimulationCommand

var contract_id: int

func _init(new_executor_entity: SimulationEntity, p_contract_id: int) -> void:
	super(new_executor_entity)
	contract_id = p_contract_id

func get_type() -> int:
	return SimulationCommand.Type.COMPLETE_CONTRACT
