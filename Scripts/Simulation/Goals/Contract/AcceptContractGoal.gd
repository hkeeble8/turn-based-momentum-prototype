class_name AcceptContractGoal
extends Goal
	
var contract: Contract

func generate_command(entity: SimulationEntity, _context: SimulationContext) -> SimulationCommand:
	if contract != null and contract.status == Contract.Status.AVAILABLE:
		return SimulationAcceptContractCommand.new(entity, contract.id)
	return null
