class_name BattleBrain
extends Resource

func decide_action(_actor: BattleActor, _battle_state: BattleState, _pathfinder: PathfinderDelegate) -> BattleAction:
	return BattleAction.new()

func build_move_action(target_cell: Vector2i) -> BattleAction:
	var action: BattleAction = BattleAction.move()
	action.target_cell = target_cell
	return action

func build_use_skill_action(skill: BattleSkill, target_actor: BattleActor) -> BattleAction:
	var action: BattleAction = BattleAction.use_skill()
	action.skill = skill
	action.target_actor = target_actor
	return action

func build_end_turn_action() -> BattleAction:
	return BattleAction.end_turn()

func find_closest_enemy(team: int, cell: Vector2i, actors: Array[BattleActor]) -> BattleActor:
	var closest_enemy: BattleActor
	var current_shortest_distance: int = BattleGlobals.MAX_INT
	for other_actor in actors:
		if other_actor.team != team:
			var distance = BattleGrid.distance(cell, other_actor.get_current_cell())
			if distance < current_shortest_distance:
				current_shortest_distance = distance
				closest_enemy = other_actor
	return closest_enemy
