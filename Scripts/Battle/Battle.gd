class_name Battle
extends Node2D

@onready var camera: Camera2D = $Camera

var director: BattleDirector
var turn_manager: BattleTurnManager
var indicator_manager: BattleIndicatorManager
var ui_manager: BattleUIManager
var pathfinder_manager: PathfinderManager
var input_manager: BattleInputManager
var actor_manager: BattleActorManager
var camera_manager: CameraManager
var behaviour_manager: BattleBehaviourManager

func _ready() -> void:
	var nodes: Dictionary = _discover_nodes()

	var tile_map_layers = TileMapLayerCollection.new(nodes.get(BattleGlobals.TILE_MAP_LAYER))

	_init_turn_manager()
	_init_indicator_manager()
	_init_ui_manager()
	_init_pathfinder_manager()
	_init_input_manager()
	_init_actor_manager()
	_init_camera_manager(tile_map_layers.region)
	_init_behaviour_manager()
	_init_battle_director()
	_register_actors(nodes.get(BattleGlobals.ACTOR))
	_register_tile_map_layers(tile_map_layers,
		Vector2(BattleGlobals.CONFIG.cell_size, BattleGlobals.CONFIG.cell_size))
	_set_actor_positions_solid()

	turn_manager.start_process_turns()

func _init_turn_manager() -> void:
	turn_manager = BattleTurnManager.new()
	turn_manager.name = "BattleTurnManager"
	add_child(turn_manager)

func _init_indicator_manager() -> void:
	indicator_manager = BattleIndicatorManager.new()
	indicator_manager.name = "BattleIndicatorManager"
	add_child(indicator_manager)

func _init_ui_manager() -> void:
	ui_manager = BattleUIManager.new()
	ui_manager.name = "BattleUIManager"
	add_child(ui_manager)

func _init_pathfinder_manager() -> void:
	pathfinder_manager = PathfinderManager.new()
	pathfinder_manager.name = "PathfinderManager"
	add_child(pathfinder_manager)

func _init_input_manager() -> void:
	input_manager = BattleInputManager.new()
	input_manager.name = "BattleInputManager"
	add_child(input_manager)

func _init_actor_manager() -> void:
	actor_manager = BattleActorManager.new()
	actor_manager.name = "BattleActorManager"
	add_child(actor_manager)

func _init_camera_manager(bounds: Rect2i) -> void:
	var pixel_bounds = Rect2i(bounds)
	pixel_bounds.size.x = bounds.size.x * BattleGlobals.CONFIG.cell_size
	pixel_bounds.size.y = bounds.size.y * BattleGlobals.CONFIG.cell_size

	camera_manager = CameraManager.new(camera, pixel_bounds)
	camera_manager.name = "CameraManager"
	add_child(camera_manager)

func _init_behaviour_manager() -> void:
	behaviour_manager = BattleBehaviourManager.new()
	behaviour_manager.name = "BattleBehaviourManager"
	add_child(behaviour_manager)

func _init_battle_director() -> void:
	director = BattleDirector.new(
		turn_manager,
		indicator_manager,
		ui_manager,
		pathfinder_manager,
		input_manager,
		actor_manager,
		camera_manager,
		behaviour_manager
	)
	director.name = "BattleDirector"
	add_child(director)

func _register_actors(actors: Array[BattleActor]) -> void:
	for actor in actors:
		turn_manager.register_actor(actor)
		actor_manager.register_actor(actor)

func _register_tile_map_layers(tile_map_layers: TileMapLayerCollection, cell_size: Vector2) -> void:
	pathfinder_manager.register_tile_map_layers(tile_map_layers, cell_size)

func _set_actor_positions_solid() -> void:
	for cell_position in actor_manager.cell_positions_actors.values():
		pathfinder_manager.set_cell_solid(cell_position, true)

func _discover_nodes() -> Dictionary:
	var actors: Array[BattleActor] = []
	var tile_map_layers: Array[TileMapLayer] = []
	for node in get_children():
		if node is BattleActor:
			actors.append(node)
		if node is TileMapLayer:
			tile_map_layers.append(node)
	return {
		BattleGlobals.ACTOR: actors,
		BattleGlobals.TILE_MAP_LAYER: tile_map_layers
	}
