class_name Region
extends Node2D

@onready var camera: Camera2D = $Camera
@onready var map: Sprite2D = $Map

var simulation: Simulation
var director: RegionDirector

var simulation_manager: SimulationManager
var pathfinder_manager: PathfinderManager
var camera_manager: CameraManager
var input_manager: RegionInputManager
var ui_manager: RegionUIManager

func _ready() -> void:
	var nodes = _discover_nodes()
	var tile_map_layers = TileMapLayerCollection.new(nodes.get(RegionGlobals.TILE_MAP_LAYER))
	simulation = nodes.get(RegionGlobals.SIMULATION)

	_init_pathfinder_manager()
	_init_camera_manager()
	_init_input_manager()
	_init_ui_manager()
	_init_simulation()
	_init_region_director()

	_register_tile_map_layers(tile_map_layers,
		Vector2(RegionGlobals.CONFIG.cell_size, RegionGlobals.CONFIG.cell_size))

func _discover_nodes() -> Dictionary:
	var simulation_node: Simulation
	var tile_map_layers: Array[TileMapLayer] = []
	for node in get_children():
		if node is TileMapLayer:
			tile_map_layers.append(node)
		if node is Simulation:
			simulation_node = node
	return {
		RegionGlobals.SIMULATION: simulation_node,
		RegionGlobals.TILE_MAP_LAYER: tile_map_layers
	}

func _clear_simulation() -> void:
	simulation.queue_free()
	simulation_manager.queue_free()

func _init_simulation() -> void:
	simulation.init(PathfinderDelegate.new(pathfinder_manager))
	if simulation.get_parent() != self:
		add_child(simulation)
	
	simulation_manager = SimulationManager.new(simulation)
	simulation_manager.name = "Simulation Manager"
	add_child(simulation_manager)


func _init_pathfinder_manager() -> void:
	pathfinder_manager = PathfinderManager.new(PathfinderManager.DirectionMode.DIAGONAL)
	pathfinder_manager.name = "Pathfinder Manager"
	add_child(pathfinder_manager)

func _init_camera_manager() -> void:
	camera_manager = CameraManager.new(camera, Rect2(Vector2.ZERO,
		map.texture.get_size() * camera.zoom))
	camera_manager.name = "Camera Manager"
	add_child(camera_manager)

func _init_input_manager() -> void:
	input_manager = RegionInputManager.new()
	input_manager.name = "Input Manager"
	add_child(input_manager)

func _init_ui_manager() -> void:
	ui_manager = RegionUIManager.new()
	ui_manager.name = "UI Manager"
	add_child(ui_manager)

func _init_region_director() -> void:
	director = RegionDirector.new(
		simulation_manager,
		pathfinder_manager,
		camera_manager,
		input_manager,
		ui_manager
	)
	add_child(director)

func _register_tile_map_layers(tile_map_layers: TileMapLayerCollection, cell_size: Vector2) -> void:
	pathfinder_manager.register_tile_map_layers(tile_map_layers, cell_size)

# TEMP TEST CODE
var saved_json: String
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_S:
			saved_json = JSON.stringify(simulation.get_state().serialize(), "\t")
			print(ProjectSettings.globalize_path("user://"))
			ResourceSaver.save(simulation.get_save(), "user://save.tres")
			print(saved_json)
		if event.keycode == KEY_L:
			_clear_simulation()
			# simulation = Simulation.deserialize(JSON.parse_string(saved_json))
			var save := ResourceLoader.load("user://save.tres") as SimulationSave
			simulation = Simulation.load(save)
			_init_simulation()
			director.simulation_manager = simulation_manager
			director.simulation_manager.simulation = simulation
			director._init_connections()
