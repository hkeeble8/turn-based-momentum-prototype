class_name SimulationLogger
extends Node

var simulation: Simulation

var log_prefix: String = "[color=green]Simulation:[/color]\t"

func _init(new_simulation: Simulation) -> void:
    simulation = new_simulation
    _init_connections()

func _init_connections() -> void:
    simulation.step_timer.timeout.connect(_on_step_timer_timeout)

func _on_step_timer_timeout() -> void:
    _handle_step_timer_timeout()

func _handle_step_timer_timeout() -> void:
    print_log("Processing Step")

func print_log(content: String) -> void:
    print_rich(log_prefix + content)