class_name CompanyBrain
extends SimulationBrain

func think(entity: SimulationEntity, context: SimulationContext) -> SimulationCommand:
	if !entity.actor.is_moving:
		if entity.hosted_by == 0:
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
				var available_contracts = host_contracts_aspect.get_contracts(context, Contract.Status.AVAILABLE)
				for contract in available_contracts:
					print("Entity %s finds available contract: %s" % [entity.name, contract.description])
			return SimulationLeaveHostCommand.new(entity)
	return null
