class_name RegionInputManager
extends Node

signal interaction_at_location(position: Vector2, cell: Vector2i)

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

func _input(event) -> void:
	if event.is_action_pressed("LocationInteraction"):
		_emit_interaction_at_location()

func _process_map_pan_inputs():
	var map_pan_direction = Vector2.ZERO

	for key_name in map_pan_key_directions.keys():
		if Input.is_action_pressed(key_name):
			map_pan_direction += map_pan_key_directions[key_name]

	if map_pan_direction != Vector2.ZERO:
		map_pan_requested.emit(map_pan_direction)
	else:
		map_pan_stopped.emit()

func _emit_interaction_at_location() -> void:
	if !_is_mouse_over_ui():
		interaction_at_location.emit(
			get_viewport().get_camera_2d().get_global_mouse_position(), # TODO - What if this is not a mouse?
			_current_mouse_to_cell()
		)

func _current_mouse_to_cell() -> Vector2i:
	var viewport_mouse_position: Vector2 = get_viewport().get_camera_2d().get_global_mouse_position()
	return RegionGrid.world_to_cell(viewport_mouse_position)

func _is_mouse_over_ui() -> bool:
	return get_viewport().gui_get_hovered_control() != null