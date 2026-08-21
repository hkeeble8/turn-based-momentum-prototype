class_name CompleteContractCommandProcessor
extends CommandProcessor

func process(context: SimulationContext, command: SimulationCommand) -> void:
	var complete_contract_command = command as SimulationCompleteContractCommand
	var contract = context.contracts.get(complete_contract_command.contract_id)
	if contract.status == Contract.Status.ACCEPTED \
		and command.executor_entity.hosted_by == contract.issuer_id:
		contract.status = Contract.Status.COMPLETED