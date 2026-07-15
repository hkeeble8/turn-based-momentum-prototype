class_name Simulation
extends Node

var step_timer: Timer
var logger: SimulationLogger
var agents: Array[SimulationAgent]

func _init() -> void:
    agents = []
    _init_step_timer()
    _init_connections()

    if SimulationGlobals.CONFIG.logger_enabled && OS.is_debug_build():
        _init_logger()

func _process_step() -> void:
    pass

func _init_connections() -> void:
    step_timer.timeout.connect(_process_step)

func _init_step_timer() -> void:
    step_timer = Timer.new()
    step_timer.wait_time = SimulationGlobals.CONFIG.step_seconds
    step_timer.autostart = true
    step_timer.name = "StepTimer"
    add_child(step_timer)

func _init_logger() -> void:
    logger = SimulationLogger.new(self)
    logger.name = "Logger"
    add_child(logger)