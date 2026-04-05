class_name AggressiveBattleBrain
extends BattleBrain

func decide_action(actor: BattleActor, battle_state: BattleState, pathfinder: PathfinderDelegate) -> BattleAction:
	var current_cell = actor.get_current_cell()
	var closest_enemy = find_closest_enemy(actor.team, current_cell, battle_state.actors)
	if closest_enemy != null:
		if BattleGrid.distance(current_cell, closest_enemy.get_current_cell()) == 1:
			if actor.action_points_current > 0:
				return build_use_skill_action(BattleGlobals.ASSETS.skill_sword_slash, closest_enemy)
			else:
				return build_end_turn_action()
		else:
			if actor.movement_points_current == 0:
				return build_end_turn_action()
			else:
				var cell_path = pathfinder.get_cell_path(current_cell, closest_enemy.get_current_cell(), true)
				if cell_path.size() == 0:
					return build_end_turn_action()
				cell_path.resize(mini(cell_path.size(), actor.movement_points_current))
				return build_move_action(cell_path.back())
	return build_end_turn_action()
