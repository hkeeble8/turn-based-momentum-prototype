class_name BattleCameraManager
extends Node

var camera: Camera2D
var is_busy: bool

var target: Node2D
var target_max_distance: float = 20.0

var pan_manual_direction: Vector2
var pan_speed: float = 200.0

func _init(new_camera: Camera2D, bounds: Rect2i):
	camera = new_camera
	_init_camera_settings(bounds)

func _process(delta: float) -> void:
	if pan_manual_direction != Vector2.ZERO:
		_process_manual_camera_pan(delta)
	elif target != null && camera.position.distance_to(target.position) > target_max_distance:
		camera.position = camera.position.move_toward(target.position, pan_speed * delta)
		_clamp_position()

func request_manual_pan(direction: Vector2):
	clear_target()
	pan_manual_direction = direction

func stop_manual_pan():
	pan_manual_direction = Vector2.ZERO

func set_target(new_target: Node2D) -> void:
	target = new_target

func clear_target() -> void:
	target = null

func _init_camera_settings(bounds: Rect2i):
	camera.anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 50

	camera.limit_left = bounds.position.x
	camera.limit_top = bounds.position.y
	camera.limit_right = bounds.size.x
	camera.limit_bottom = bounds.size.y

func _process_manual_camera_pan(delta: float) -> void:
	camera.position += pan_manual_direction * pan_speed * delta
	_clamp_position()
	
func _clamp_position() -> void:
	var half_viewport_size = (camera.get_viewport_rect().size / camera.zoom) / 2

	camera.position.x = clamp(
		camera.position.x,
		camera.limit_left + half_viewport_size.x,
		camera.limit_right - half_viewport_size.x
	)

	camera.position.y = clamp(
		camera.position.y,
		camera.limit_top + half_viewport_size.y,
		camera.limit_bottom - half_viewport_size.y
	)
