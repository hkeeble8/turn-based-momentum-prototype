class_name BattleBehaviourManager
extends Node

signal move_requested(actor: BattleActor, cell: Vector2i)
signal end_turn_requested
signal use_skill_requested(skill: BattleSkill, actor: BattleActor, target: BattleActor)

func decide_action(actor: BattleActor, battle_state: BattleState, pathfinder: PathfinderDelegate) -> void:
	await get_tree().create_timer(0.5).timeout
	var action: BattleAction = actor.brain.decide_action(actor, battle_state, pathfinder)
	match action.type:
		BattleAction.Type.END_TURN:
			end_turn_requested.emit()
		BattleAction.Type.USE_SKILL:
			use_skill_requested.emit(action.skill, actor, action.target_actor)
		BattleAction.Type.MOVE:
			move_requested.emit(actor, action.target_cell)
