class_name MoveCommandProcessor
extends CommandProcessor

signal command_processed(actor: RegionActor, cell: Vector2i)

func register(_callback: Callable) -> void:
	command_processed.connect(_callback)

func process(actors: Dictionary[int, RegionActor], command: SimulationCommand) -> void:
	var move_command = command as SimulationMoveCommand
	var executor_actor = actors[move_command.executor_entity_id]
	var destination_actor = actors[move_command.destination_entity_id]
	command_processed.emit(executor_actor, destination_actor.get_current_cell())