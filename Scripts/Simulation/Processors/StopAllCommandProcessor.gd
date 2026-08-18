class_name StopAllCommandProcessor
extends CommandProcessor

func process(_context: SimulationContext, command: SimulationCommand) -> void:
	command.executor_entity.actor.stop_move()
