class_name CompanyBrain
extends SimulationBrain

func think(entity: SimulationEntity, context: SimulationContext) -> SimulationCommand:
	if !entity.actor.is_moving:
		var accepted_contracts = _get_accepted_contracts(entity, context)
		if entity.hosted_by == 0:
			if !accepted_contracts.is_empty():
				var contract = accepted_contracts[0]
				if contract != null:
					var contract_target_entity = context.entities.get(contract.target_id)
					var bandit_camp_aspect = contract_target_entity.aspects.get(SimulationAspectType.BANDIT_CAMP)
					if !bandit_camp_aspect.cleared:
						return SimulationMoveCommand.new(entity, contract_target_entity.position)
					else:
						var contract_issuer = context.entities.get(contract.issuer_id)
						return SimulationMoveCommand.new(entity, contract_issuer.position)
			else:
				var settlements = context.get_entities([SimulationAspectType.SETTLEMENT])
				var furthest_settlement = settlements[0]
				for settlement in settlements:
					if entity.position.distance_to(furthest_settlement.position) < entity.position.distance_to(settlement.position):
						furthest_settlement = settlement
				return SimulationMoveCommand.new(entity, furthest_settlement.position)
		else:
			var host = context.entities.get(entity.hosted_by)
			var host_contracts_aspect = host.aspects.get(SimulationAspectType.CONTRACTS)
			if host_contracts_aspect != null:
				var available_contracts = host_contracts_aspect.get_available_issued_contracts(context, host.id)
				for contract in available_contracts:
					return SimulationAcceptContractCommand.new(entity, contract.id)
			return SimulationLeaveHostCommand.new(entity)
	return null

func _get_accepted_contracts(entity: SimulationEntity, context: SimulationContext) -> Array[Contract]:
	var contracts_aspect = entity.aspects.get_or_add(SimulationAspectType.CONTRACTS, SimulationContractsAspect.new())
	return contracts_aspect.get_accepted_contracts(context, entity.id)