class_name Region
extends Node2D

@onready var player_actor: RegionActor = $Player
@onready var region_map_sprite: Sprite2D = $RegionMap
@onready var camera: Camera2D = $Camera

var director: RegionDirector
var input_manager: RegionInputManager
var camera_manager: CameraManager
var pathfinder_manager: PathfinderManager
var simulation_manager: SimulationManager
var actor_manager: RegionActorManager

var command_processors: Dictionary[int, CommandProcessor]

func _ready() -> void:
	var nodes: Dictionary = _discover_nodes()
	var tile_map_layers = TileMapLayerCollection.new(nodes.get(RegionGlobals.TILE_MAP_LAYER))

	_init_input_manager()
	_init_camera_manager()
	_init_pathfinder_manager()
	_init_simulation_manager()
	_init_actor_manager()
	_init_commmand_processors()
	_init_region_director()

	_register_actors(nodes.get(RegionGlobals.ACTOR))
	_register_tile_map_layers(tile_map_layers,
		Vector2(RegionGlobals.CONFIG.cell_size, RegionGlobals.CONFIG.cell_size))

func _init_input_manager() -> void:
	input_manager = RegionInputManager.new()
	input_manager.name = "Region Input Manager"
	add_child(input_manager)

func _init_camera_manager() -> void:
	camera_manager = CameraManager.new(camera, Rect2(Vector2.ZERO,
		region_map_sprite.texture.get_size()))
	camera_manager.name = "Camera Manager"
	add_child(camera_manager)

func _init_pathfinder_manager() -> void:
	pathfinder_manager = PathfinderManager.new(PathfinderManager.DirectionMode.DIAGONAL)
	pathfinder_manager.name = "Pathfinder Manager"
	add_child(pathfinder_manager)

func _init_simulation_manager() -> void:
	simulation_manager = SimulationManager.new()
	simulation_manager.name = "Simulation Manager"
	add_child(simulation_manager)

func _init_actor_manager() -> void:
	actor_manager = RegionActorManager.new(get_world_2d())
	actor_manager.name = "Region Actor Manager"
	add_child(actor_manager)

func _init_commmand_processors() -> void:
	var move_command_processor = MoveCommandProcessor.new()
	move_command_processor.name = "Move Command Processor"
	add_child(move_command_processor)

	command_processors[SimulationCommand.Type.MOVE] = move_command_processor

func _init_region_director() -> void:
	director = RegionDirector.new(
		input_manager,
		camera_manager,
		pathfinder_manager,
		simulation_manager,
		actor_manager,
		command_processors
	)
	director.name = "RegionDirector"
	director.player_actor = player_actor
	add_child(director)

func _register_actors(actors: Array[RegionActor]) -> void:
	for actor in actors:
		simulation_manager.register_actor(actor)
		actor_manager.register_actor(actor)

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
