class_name SimulationLogger
extends Node

var simulation: Simulation

var log_prefix: String = "[color=green]Simulation:[/color]\t"

func _init(new_simulation: Simulation) -> void:
	simulation = new_simulation
	_init_connections()

func _init_connections() -> void:
	simulation.step_timer.timeout.connect(_on_step_timer_timeout)
	simulation.simulation_day_start.connect(_on_simulation_day_start)
	simulation.agent_registered.connect(_on_agent_registered)
	simulation.agent_step_processed.connect(_on_agent_step_processed)

func _on_step_timer_timeout() -> void:
	_handle_step_timer_timeout()

func _on_simulation_day_start(day: int) -> void:
	_handle_simulation_day_start(day)

func _on_agent_registered(agent: SimulationAgent) -> void:
	_handle_agent_registered(agent)

func _on_agent_step_processed(agent: SimulationAgent) -> void:
	_handle_agent_step_processed(agent)

func _handle_step_timer_timeout() -> void:
	_print_log("Processing Step")

func _handle_simulation_day_start(day: int) -> void:
	_print_log("[color=red]--- Day %s Start ---[/color]" % day)

func _handle_agent_registered(agent: SimulationAgent) -> void:
	_print_log("Agent " + agent.name + " was registered:\n" + _dump_resource(agent.state))

func _handle_agent_step_processed(agent: SimulationAgent) -> void:
	_print_log("Step processed for:\t " + agent.name + ":\n" + _dump_resource(agent.state))

func _print_log(content: String) -> void:
	var datetime = _format_datetime_dict(Time.get_datetime_dict_from_system())
	print_rich(datetime + "\t" + log_prefix + content)

func _dump_resource(resource: Resource) -> String:
	var data := {}

	for property in resource.get_property_list():
		if property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			data[property.name] = resource.get(property.name)

	return JSON.stringify(data, " \t")

func _format_datetime_dict(datetime: Dictionary) -> String:
	return "%04d-%02d-%02d %02d:%02d:%02d" % [
		datetime.year,
		datetime.month,
		datetime.day,
		datetime.hour,
		datetime.minute,
		datetime.second
	]
