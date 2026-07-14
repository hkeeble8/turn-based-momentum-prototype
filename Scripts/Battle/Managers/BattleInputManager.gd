class_name BattleInputManager
extends Node

signal mouse_cell_changed(mouse_cell: Vector2i)
signal interaction_at_location(position: Vector2, cell: Vector2i)
signal mouse_over_ui()
signal end_turn_requested()
signal cancel_requested()

signal map_pan_requested(direction: Vector2i)
signal map_pan_stopped()

var current_mouse_cell: Vector2i

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
	if event is InputEventMouseMotion:
		if !_is_mouse_over_ui():
			update_mouse_cell()
		else:
			update_mouse_over_ui()
	if event.is_action_pressed("LocationInteraction"):
		_emit_interaction_at_location()
	if event.is_action_released("EndTurn"):
		end_turn_requested.emit()
	if event.is_action_pressed("Cancel"):
		cancel_requested.emit()

func _process_map_pan_inputs():
	var map_pan_direction = Vector2.ZERO

	for key_name in map_pan_key_directions.keys():
		if Input.is_action_pressed(key_name):
			map_pan_direction += map_pan_key_directions[key_name]

	if map_pan_direction != Vector2.ZERO:
		map_pan_requested.emit(map_pan_direction)
	else:
		map_pan_stopped.emit()

func update_mouse_cell() -> void:
	var new_mouse_cell = _current_mouse_to_cell()
	if new_mouse_cell != current_mouse_cell:
		current_mouse_cell = new_mouse_cell
		mouse_cell_changed.emit(current_mouse_cell)

func update_mouse_over_ui() -> void:
	current_mouse_cell = Vector2i(-1, -1)
	mouse_over_ui.emit()

func _emit_interaction_at_location() -> void:
	if !_is_mouse_over_ui():
		interaction_at_location.emit(
			get_viewport().get_camera_2d().get_global_mouse_position(), # TODO - What if this is not a mouse?
			_current_mouse_to_cell()
		)

func _current_mouse_to_cell() -> Vector2i:
	var viewport_mouse_position: Vector2 = get_viewport().get_camera_2d().get_global_mouse_position()
	return BattleGrid.world_to_cell(viewport_mouse_position)

func _is_mouse_over_ui() -> bool:
	return get_viewport().gui_get_hovered_control() != null
