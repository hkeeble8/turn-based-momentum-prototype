class_name SimulationLogger
extends SimulationObserver

func on_entity_added(context: SimulationContext, entity: SimulationEntity) -> void:
    _print(context, "[color=yellow]Entity added:[/color]" + JSON.stringify(entity.serialize()))

func on_commands_enqueued(context: SimulationContext, commands: Array[SimulationCommand]) -> void:
    for command in commands:
        _print(context, "[color=yellow]Command enqueued:[/color]" + JSON.stringify(command.serialize()))

func _print(context: SimulationContext, message: String) -> void:
    print_rich(
        "[color=green]Simulation (D:%s,S:%s):[/color]\t" % [context.day, context.steps_today]
        + message)