class_name MoveCommandProcessor
extends CommandProcessor

var pathfinder_delegate: PathfinderDelegate

func _init(new_pathfinder_delegate: PathfinderDelegate) -> void:
	pathfinder_delegate = new_pathfinder_delegate

func process(_context: SimulationContext, command: SimulationCommand) -> void:
	var move_command = command as SimulationMoveCommand
	var actor = command.executor_entity.actor
	actor.move_on_path(pathfinder_delegate.get_cell_path(actor.get_current_cell(),
		move_command.position))
