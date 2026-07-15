class_name Region
extends Node2D

@onready var region_map_sprite: Sprite2D = $RegionMap
@onready var camera: Camera2D = $Camera

var director: RegionDirector
var input_manager: RegionInputManager
var camera_manager: CameraManager
var pathfinder_manager: PathfinderManager

func _ready() -> void:
	var nodes: Dictionary = _discover_nodes()
	var tile_map_layers = TileMapLayerCollection.new(nodes.get(BattleGlobals.TILE_MAP_LAYER))

	_init_input_manager()
	_init_camera_manager()
	_init_pathfinder_manager()
	_init_region_director()

	_register_tile_map_layers(tile_map_layers,
		Vector2(RegionGlobals.CONFIG.cell_size, RegionGlobals.CONFIG.cell_size))

func _init_input_manager() -> void:
	input_manager = RegionInputManager.new()
	input_manager.name = "RegionInputManager"
	add_child(input_manager)

func _init_camera_manager() -> void:
	camera_manager = CameraManager.new(camera, Rect2(Vector2.ZERO,
		region_map_sprite.texture.get_size()))
	camera_manager.name = "CameraManager"
	add_child(camera_manager)

func _init_pathfinder_manager() -> void:
	pathfinder_manager = PathfinderManager.new()
	pathfinder_manager.name = "PathfinderManager"
	add_child(pathfinder_manager)

func _init_region_director() -> void:
	director = RegionDirector.new(
		input_manager,
		camera_manager,
		pathfinder_manager
	)
	director.name = "RegionDirector"
	add_child(director)

func _register_tile_map_layers(tile_map_layers: TileMapLayerCollection, cell_size: Vector2) -> void:
	pathfinder_manager.register_tile_map_layers(tile_map_layers, cell_size)

func _discover_nodes() -> Dictionary:
	var actors: Array[RegionActor] = []
	var tile_map_layers: Array[TileMapLayer] = []
	for node in get_children():
		if node is RegionActor:
			actors.append(node)
		if node is TileMapLayer:
			tile_map_layers.append(node)
	return {
		RegionGlobals.ACTOR: actors,
		RegionGlobals.TILE_MAP_LAYER: tile_map_layers
	}
