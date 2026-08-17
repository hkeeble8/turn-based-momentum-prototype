class_name Simulation
extends Node2D

signal player_entered_settlement(settlement: SettlementViewModel)

var next_entity_id: int = 1
var day: int = 1
var steps_today: int = 1
var player_entities: Dictionary[int, SimulationEntity]
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
	player_entities = {}
	processors = {}

func init(new_pathfinder_delegate: PathfinderDelegate) -> void:
	pathfinder_delegate = new_pathfinder_delegate
	_init_processors()

func _init_processors() -> void:
	processors[SimulationCommand.Type.MOVE] = MoveCommandProcessor.new(pathfinder_delegate)

func _ready() -> void:
	_discover_nodes(self)

func get_state() -> SimulationState:
	return SimulationState.new(
		next_entity_id,
		day,
		steps_today,
		entities
	)

func step() -> void:
	var context = _context()
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
	processors[command.get_type()].process(_context(), command)

func _discover_nodes(node: Node):
	var parent: SimulationEntity
	if node is SimulationEntity:
		parent = node as SimulationEntity
	for n in node.get_children():
		if n is SimulationEntity:
			_init_entity_node(
				n as SimulationEntity,
				parent
			)
		_discover_nodes(n)

func _init_entity_node(entity: SimulationEntity, parent: SimulationEntity) -> void:
	if entity.id == null || entity.id == 0:
		entity.set_id(_get_next_entity_id())
	entities[entity.id] = entity

	if entity.actor != null:
		entity.position = RegionGrid.world_to_cell(entity.actor.position)

	entity.collision.connect(_on_entity_collision)
	entity.sighted.connect(_on_entity_sighted)
	entity.lost_sight.connect(_on_entity_lost_sight)

	if parent != null:
		_entity_set_owner(entity, parent)

	if entity.aspects.has(SimulationAspectType.PLAYER):
		player_entities[entity.id] = entity
	elif !entity.aspects.has(SimulationAspectType.SETTLEMENT) && entity.actor != null:
		entity.actor.visible = false

func _entity_set_owner(entity: SimulationEntity, owner_entity: SimulationEntity) -> void:
	var entity_relationships = entity.aspects.get_or_add(SimulationAspectType.RELATIONSHIPS,
		SimulationRelationshipAspect.new())
	var owner_entity_relationships = owner_entity.aspects.get_or_add(SimulationAspectType.RELATIONSHIPS,
		SimulationRelationshipAspect.new())

	entity_relationships.add(SimulationRelationshipType.OWNED_BY, owner_entity.id)
	owner_entity_relationships.add(SimulationRelationshipType.OWNER_OF, entity.id)

func _on_entity_collision(entity: SimulationEntity, other: SimulationEntity) -> void:
	if player_entities.has(entity.id) && other.aspects.has(SimulationAspectType.SETTLEMENT):
		player_entered_settlement.emit(SettlementViewModel.new(other, _context()))

func _on_entity_sighted(entity: SimulationEntity, other: SimulationEntity) -> void:
	if player_entities.has(entity.id):
		other.actor.visible = true

func _on_entity_lost_sight(entity: SimulationEntity, other: SimulationEntity) -> void:
	if player_entities.has(entity.id):
		other.actor.visible = false

func _get_next_entity_id() -> int:
	next_entity_id += 1
	return next_entity_id - 1

func _context() -> SimulationContext:
	return SimulationContext.new(day, steps_today, entities)
