class_name AcceptContractGoal
extends Goal
	
var contract: Contract

func generate_command(entity: SimulationEntity, _context: SimulationContext) -> SimulationCommand:
	return SimulationAcceptContractCommand.new(entity, contract.id)
