class_name BattleActorManager
extends Node

signal actor_position_changed(old_cell_position: Vector2i, new_cell_position: Vector2i)
signal actor_action_completed(actor: BattleActor)
signal actor_eliminated(actor: BattleActor)

var actor_cell_positions: Dictionary[Vector2i, BattleActor] = {}
var cell_positions_actors: Dictionary[BattleActor, Vector2i] = {}
var actor_teams: Dictionary[int, Array] = {}

func register_actor(actor: BattleActor) -> void:
	if cell_positions_actors.has(actor):
		print("[WARNING] BattleActor %s already tracked, skipping duplicate register in actor "
			+"tracker." % actor.name)
		return
	
	_set_actor_position(actor)
	_add_actor_to_team(actor)
	actor.position_changed.connect(_on_actor_position_changed)
	actor.eliminated.connect(_on_actor_eliminated)
	actor.action_completed.connect(_on_actor_action_completed)

	var cell_position = cell_positions_actors[actor]
	print("Registering actor " + actor.name + " with actor tracker at cell %s,%s."
		% [cell_position.x, cell_position.y])

func unregister_actor(actor: BattleActor) -> void:
	var actor_position = cell_positions_actors.get(actor)
	if actor_position != null:
		actor_cell_positions.erase(actor_position)
	cell_positions_actors.erase(actor)
	_remove_actor_from_team(actor)

func is_multiple_teams_remaining() -> bool:
	return actor_teams.size() > 1

func _on_actor_position_changed(actor: BattleActor) -> void:
	var old_cell_position: Vector2i = cell_positions_actors.get(actor)
	actor_cell_positions.erase(cell_positions_actors[actor])
	cell_positions_actors.erase(actor)
	_set_actor_position(actor)

	var new_cell_position = cell_positions_actors.get(actor)
	actor_position_changed.emit(old_cell_position, new_cell_position)

func _on_actor_eliminated(actor: BattleActor) -> void:
	actor_cell_positions.erase(cell_positions_actors[actor])
	cell_positions_actors.erase(actor)
	actor_eliminated.emit(actor)

func _on_actor_action_completed(actor: BattleActor) -> void:
	actor_action_completed.emit(actor)

func _set_actor_position(actor: BattleActor) -> void:
	var cell_position = BattleGrid.world_to_cell(actor.global_position)
	actor_cell_positions[cell_position] = actor
	cell_positions_actors[actor] = cell_position

func _add_actor_to_team(actor: BattleActor) -> void:
	actor_teams.get_or_add(actor.team, []).append(actor)

func _remove_actor_from_team(actor: BattleActor) -> void:
	var actor_team = actor_teams.get(actor.team)
	if actor_team != null:
		actor_team.erase(actor)
		if actor_team.is_empty():
			actor_teams.erase(actor.team)
