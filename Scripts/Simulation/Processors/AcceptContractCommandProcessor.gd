class_name AcceptContractCommandProcessor
extends CommandProcessor

func process(context: SimulationContext, command: SimulationCommand) -> void:
	var accept_contract_command = command as SimulationAcceptContractCommand
	var contract = context.contracts.get(accept_contract_command.contract_id)
	if contract != null:
		contract.contractor_id = command.executor_entity.id
		contract.status = Contract.Status.ACCEPTED
		var entity_contracts_aspect = command.executor_entity.aspects.get_or_add(SimulationAspectType.CONTRACTS, SimulationContractsAspect.new())
		var entity_memory_aspect = command.executor_entity.aspects.get_or_add(SimulationAspectType.MEMORY, SimulationMemoryAspect.new())
		var target_entity = context.entities.get(contract.target_id)
		if target_entity != null:
			entity_memory_aspect.entity_location_learned(contract.target_id, target_entity.position)
		entity_contracts_aspect.add_contract(accept_contract_command.contract_id)
