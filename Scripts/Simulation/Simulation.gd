class_name Simulation
extends Node2D

var next_entity_id: int = 1
var day: int = 1
var steps_today: int = 1
var player_entities: Array[SimulationEntity]
var entities: Dictionary[int, SimulationEntity]
var processors: Dictionary[int, CommandProcessor]

var pathfinder_delegate: PathfinderDelegate

static func deserialize(data: Dictionary) -> Simulation:
	var simulation = Simulation.new()
	for entity_id in data["entities"].keys():
		simulation.add_child(SimulationEntityFactory.deserialize(data["entities"].get(entity_id)))
	return simulation

func _init() -> void:
	entities = {}
	player_entities = []
	processors = {}

func init(new_pathfinder_delegate: PathfinderDelegate) -> void:
	pathfinder_delegate = new_pathfinder_delegate
	_init_processors()

func _init_processors() -> void:
	processors[SimulationCommand.Type.MOVE] = MoveCommandProcessor.new(pathfinder_delegate)

func _ready() -> void:
	_discover_nodes()

func get_state() -> SimulationState:
	return SimulationState.new(
		next_entity_id,
		day,
		steps_today,
		entities
	)

func step() -> void:
	var context = SimulationContext.new(day, steps_today, entities)
	for entity in entities.values():
		var commands = entity.step(context)
		for command in commands:
			processors[command.get_type()].process(context, command)
	if steps_today >= 10:
		steps_today = 1
		day += 1
	else:
		steps_today += 1

func process_command(command: SimulationCommand) -> void:
	var context = SimulationContext.new(day, steps_today, entities)
	processors[command.get_type()].process(context, command)

func _discover_nodes():
	for node in get_children():
		if node is SimulationEntity:
			var entity = node as SimulationEntity
			if entity.id == null || entity.id == 0:
				entity.id = _get_next_entity_id()
			entities[entity.id] = entity
			entity.collision.connect(_on_entity_collision)
			if entity.aspects.has(SimulationAspect.Type.PLAYER):
				player_entities.append(entity)

func _on_entity_collision(entity: SimulationEntity, other: SimulationEntity) -> void:
	print("Entity %s collided with entity %s" % [entity.name, other.name])

func _get_next_entity_id() -> int:
	next_entity_id += 1
	return next_entity_id - 1
