class_name Region
extends Node2D

@onready var region_map_sprite: Sprite2D = $RegionMap
@onready var camera: Camera2D = $Camera

var director: RegionDirector
var input_manager: RegionInputManager
var camera_manager: CameraManager

func _ready() -> void:
	_init_input_manager()
	_init_camera_manager()
	_init_region_director()

func _init_input_manager() -> void:
	input_manager = RegionInputManager.new()
	input_manager.name = "RegionInputManager"
	add_child(input_manager)

func _init_camera_manager() -> void:
	camera_manager = CameraManager.new(camera, Rect2(Vector2.ZERO,
		region_map_sprite.texture.get_size()))
	camera_manager.name = "CameraManager"
	add_child(camera_manager)

func _init_region_director() -> void:
	director = RegionDirector.new(
		input_manager,
		camera_manager
	)
	director.name = "RegionDirector"
	add_child(director)
