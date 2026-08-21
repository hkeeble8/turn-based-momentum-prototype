class_name CompanyBrain
extends SimulationBrain

const MOVE_TO_POSITION_PRIORITY = 1
const ACCEPT_CONTRACT_PRIORITY = 2
const PURSUE_CONTRACT_PRIORITY = 3
const COMPLETE_CONTRACT_PRIORITY = 4

func think(entity: SimulationEntity, context: SimulationContext) -> SimulationCommand:
	var possible_goals = _determine_possible_goals(entity, context)
	possible_goals.sort_custom(func(a, b): return a.priority > b.priority)
	for goal in possible_goals:
		var command = possible_goals[0].generate_command(entity, context)
		if command != null:
			return command
	return null

func _determine_possible_goals(entity: SimulationEntity, context: SimulationContext) -> Array[Goal]:
	var possible_goals: Array[Goal] = []
	possible_goals.append_array(_get_accept_contract_goals(entity, context))
	possible_goals.append_array(_get_pursue_contract_goals(entity, context))
	possible_goals.append_array(_get_move_to_position_goals(entity, context))
	return possible_goals

func _get_pursue_contract_goals(entity: SimulationEntity, context: SimulationContext) -> Array[Goal]:
	var goals: Array[Goal] = []
	var accepted_contracts = _get_accepted_contracts(entity, context)
	for contract in accepted_contracts:
		goals.append(_create_pursue_contract_goal(contract))
	return goals

func _get_accept_contract_goals(entity: SimulationEntity, context: SimulationContext) -> Array[Goal]:
	var goals: Array[Goal] = []
	if entity.hosted_by != 0:
		var host = context.entities.get(entity.hosted_by)
		var host_contracts_aspect = host.aspects.get(SimulationAspectType.CONTRACTS)
		if host_contracts_aspect != null:
			var available_contracts = host_contracts_aspect.get_available_issued_contracts(context, host.id)
			for contract in available_contracts:
				goals.append(_create_accept_contract_goal(contract))
	return goals

func _get_move_to_position_goals(entity: SimulationEntity, context: SimulationContext) -> Array[Goal]:
	var goals: Array[Goal] = []
	if !entity.actor.is_moving:
		var settlements = context.get_entities([SimulationAspectType.SETTLEMENT])
		var furthest_settlement = settlements[0]
		for settlement in settlements:
			if entity.position.distance_to(furthest_settlement.position) < entity.position.distance_to(settlement.position):
				furthest_settlement = settlement
		goals.append(_create_move_to_position_goal(furthest_settlement.position))
	return goals

func _create_accept_contract_goal(contract: Contract) -> AcceptContractGoal:
	var accept_contract_goal = AcceptContractGoal.new()
	accept_contract_goal.priority = ACCEPT_CONTRACT_PRIORITY
	accept_contract_goal.contract = contract
	return accept_contract_goal

func _create_pursue_contract_goal(contract: Contract) -> PursueContractGoal:
	var pursue_contract_goal = PursueContractGoal.new()
	pursue_contract_goal.contract = contract
	pursue_contract_goal.priority = PURSUE_CONTRACT_PRIORITY
	return pursue_contract_goal

func _create_move_to_position_goal(position: Vector2i) -> MoveToPositionGoal:
	var move_to_position_goal = MoveToPositionGoal.new()
	move_to_position_goal.position = position
	move_to_position_goal.priority = MOVE_TO_POSITION_PRIORITY
	return move_to_position_goal

func _get_accepted_contracts(entity: SimulationEntity, context: SimulationContext) -> Array[Contract]:
	var contracts_aspect = entity.aspects.get_or_add(SimulationAspectType.CONTRACTS, SimulationContractsAspect.new())
	return contracts_aspect.get_accepted_contracts(context, entity.id)
