class_name LeaveHostCommandProcessor
extends CommandProcessor

func process(_context: SimulationContext, command: SimulationCommand) -> void:
	command.executor_entity.leave_host()
