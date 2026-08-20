class_name SimulationAcceptContractCommand
extends SimulationCommand

var contract_id: int

func _init(executor_entity: SimulationEntity, contract_id: int) -> void:
	super(executor_entity)
	self.contract_id = contract_id

func get_type() -> int:
	return SimulationCommand.Type.ACCEPT_CONTRACT
