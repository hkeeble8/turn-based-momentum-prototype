class_name PursueContractGoal
extends Goal

var contract: Contract

func generate_command(entity: SimulationEntity, context: SimulationContext) -> SimulationCommand:
	var target_entity = context.entities.get(contract.target_id)

	# TODO - should this just be a specific "is_cleared" aspect?
	var bandit_camp_aspect = target_entity.aspects.get(SimulationAspectType.BANDIT_CAMP)

	if entity.hosted_by != 0:
		if entity.hosted_by == contract.issuer_id and bandit_camp_aspect.cleared:
			return SimulationCompleteContractCommand.new(entity, contract.id)
		else:
			return SimulationLeaveHostCommand.new(entity)
	if target_entity != null:
		if !bandit_camp_aspect.cleared:
			return SimulationMoveCommand.new(entity, target_entity.position)
		else:
			var issuer_entity = context.entities.get(contract.issuer_id)
			return SimulationMoveCommand.new(entity, issuer_entity.position)
	return null
