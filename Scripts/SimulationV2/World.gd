class_name World
extends Node2D

@onready var simulation: SimulationV2 = $Simulation
var saved_json: String

# TEMP TEST CODE
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_S:
			saved_json = JSON.stringify(simulation.get_state().serialize())
			print(saved_json)
		if event.keycode == KEY_L:
			remove_child(simulation)
			simulation.queue_free()

			var saved_data = JSON.parse_string(saved_json)
			simulation = SimulationV2.deserialize(saved_data)
			add_child(simulation)
