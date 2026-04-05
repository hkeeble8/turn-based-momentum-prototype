class_name BattleTurnManager
extends Node

var current_actor: BattleActor
var current_actor_idx: int
var actors: Array[BattleActor]

signal turn_started

func _ready() -> void:
	actors = []
	current_actor = null
	current_actor_idx = 0

func register_actor(actor: BattleActor) -> void:
	if actors.has(actor):
		print("[WARNING] BattleActor %s already has turns managed, "
			+"skipping duplicate register in turn manager." % actor.name)
		return

	print("Registering actor " + actor.name + " with turn mananger.")
	actors.append(actor)
	actor.connect("turn_finished", _actor_turn_finished)

func unregister_actor(actor: BattleActor) -> void:
	actors.erase(actor)

func start_process_turns() -> void:
	print("Starting to process turns.")
	current_actor_idx = -1
	_start_next_turn()

func end_turn_requested() -> void:
	if !current_actor.is_busy:
		_actor_turn_finished(current_actor)

func _start_next_turn() -> void:
	print("Starting next turn.")
	current_actor_idx = current_actor_idx + 1
	if current_actor_idx >= actors.size():
		current_actor_idx = 0
	if actors.size() == 0:
		print("No actors in turn manager, stopped turn processing.")
		return
	current_actor = actors[current_actor_idx]
	print("Starting %s's turn." % current_actor.name)
	current_actor.start_turn()
	turn_started.emit(current_actor)
	
func _actor_turn_finished(actor: BattleActor) -> void:
	if current_actor != actor:
		print("[WARNING] Received turn finish for %s, but it is currently %s's turn!"
			% [actor.name, current_actor.name])
		return

	print("%s's turn has finished." % current_actor.name)
	_start_next_turn()
