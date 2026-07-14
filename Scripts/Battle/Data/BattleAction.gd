class_name BattleAction
extends Resource

enum Type {
	MOVE,
	USE_SKILL,
	END_TURN
}

static func move() -> BattleAction:
	var action: BattleAction = BattleAction.new()
	action.type = Type.MOVE
	return action

static func use_skill() -> BattleAction:
	var action: BattleAction = BattleAction.new()
	action.type = Type.USE_SKILL
	return action

static func end_turn() -> BattleAction:
	var action: BattleAction = BattleAction.new()
	action.type = Type.END_TURN
	return action

var type: Type
var target_cell: Vector2i
var target_actor: BattleActor
var skill: BattleSkill
