class_name BattleActorManager
extends Node

signal actor_position_changed(old_cell_position: Vector2i, new_cell_position: Vector2i)
signal actor_action_completed(actor: BattleActor)
signal actor_eliminated(actor: BattleActor)

var actor_cell_positions: Dictionary[Vector2i, BattleActor] = {}
var cell_positions_actors: Dictionary[BattleActor, Vector2i] = {}

func register_actor(actor: BattleActor) -> void:
	if cell_positions_actors.has(actor):
		print("[WARNING] BattleActor %s already tracked, skipping duplicate register in actor "
			+"tracker." % actor.name)
		return
	
	_set_actor_position(actor)
	actor.position_changed.connect(_on_actor_position_changed)
	actor.eliminated.connect(_on_actor_eliminated)
	actor.action_completed.connect(_on_actor_action_completed)

	var cell_position = cell_positions_actors[actor]
	print("Registering actor " + actor.name + " with actor tracker at cell %s,%s."
		% [cell_position.x, cell_position.y])

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
