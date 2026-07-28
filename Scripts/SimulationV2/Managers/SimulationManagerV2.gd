class_name SimulationManagerV2
extends Node

var simulation: SimulationV2
var step_timer: Timer

func _init(new_simulation: SimulationV2) -> void:
	simulation = new_simulation
	_init_simulation()

func play() -> void:
	step_timer.start()

func pause() -> void:
	step_timer.stop()

func _init_simulation() -> void:
	step_timer = Timer.new()
	step_timer.wait_time = 0.5
	step_timer.autostart = true
	step_timer.name = "StepTimer"
	step_timer.timeout.connect(_on_step_timer_timeout)
	add_child(step_timer)

func _on_step_timer_timeout() -> void:
	simulation.step()
