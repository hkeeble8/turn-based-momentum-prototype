class_name Simulation
extends Node

signal simulation_day_start(day: int)
signal agent_registered(agent: SimulationAgent)
signal agent_step_processed(agent: SimulationAgent)

var day: int
var steps_today: int
var step_timer: Timer
var logger: SimulationLogger
var agents: Array[SimulationAgent]

func _init() -> void:
    agents = []
    day = 1
    steps_today = 0
    _init_step_timer()
    _init_connections()

    if SimulationGlobals.CONFIG.logger_enabled && OS.is_debug_build():
        _init_logger()

func register_agent(agent: SimulationAgent) -> void:
    agents.append(agent)
    add_child(agent)
    agent_registered.emit(agent)

func _process_step() -> void:
    var day_start: bool = false
    steps_today += 1
    if steps_today >= SimulationGlobals.CONFIG.steps_per_day:
        steps_today = 0
        day += 1
        day_start = true
        simulation_day_start.emit(day)

    for agent in agents:
        agent.process_step(day_start)
        agent_step_processed.emit(agent)

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