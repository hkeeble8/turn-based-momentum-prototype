class_name RegionInputManager
extends Node

signal map_pan_requested(direction: Vector2i)
signal map_pan_stopped()

var map_pan_directions_active = []
var map_pan_key_directions := {
	"PanMapRight": Vector2.RIGHT,
	"PanMapLeft": Vector2.LEFT,
	"PanMapDown": Vector2.DOWN,
	"PanMapUp": Vector2.UP
}

func _process(_delta):
	_process_map_pan_inputs()

func _process_map_pan_inputs():
	var map_pan_direction = Vector2.ZERO

	for key_name in map_pan_key_directions.keys():
		if Input.is_action_pressed(key_name):
			map_pan_direction += map_pan_key_directions[key_name]

	if map_pan_direction != Vector2.ZERO:
		map_pan_requested.emit(map_pan_direction)
	else:
		map_pan_stopped.emit()