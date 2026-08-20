class_name Simulation
extends Node2D

signal player_entered_settlement(settlement: SettlementViewModel)

var next_entity_id: int = 1
var date_time: SimulationDateTime = SimulationDateTime.new(1, 1, 1, 1)
var player_entities: Dictionary[int, SimulationEntity]
var entities: Dictionary[int, SimulationEntity]
var processors: Dictionary[int, CommandProcessor]

var pathfinder_delegate: PathfinderDelegate

static func load(save: SimulationSave) -> Simulation:
	var simulation = Simulation.new()
	for entity_id in save.entities.keys():
		simulation.add_child(SimulationEntityFactory.load(save.entities[entity_id]))
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
	processors[SimulationCommand.Type.STOP_ALL] = StopAllCommandProcessor.new()
	processors[SimulationCommand.Type.LEAVE_HOST] = LeaveHostCommandProcessor.new()

func _ready() -> void:
	_discover_nodes(self)

func get_save() -> SimulationSave:
	return SimulationSave.new(
		next_entity_id,
		date_time,
		entities
	)

func step() -> void:
	var context = _context()
	for entity in entities.values():
		var commands = entity.step(context)
		for command in commands:
			processors[command.get_type()].process(context, command)
	date_time.step()

func process_command(command: SimulationCommand) -> void:
	processors[command.get_type()].process(_context(), command)

func entity_leave_host(entity_id: int) -> void:
	var entity = entities.get(entity_id)
	if entity != null:
		_handle_entity_exit_host(entity)

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
	entity.left_host.connect(_handle_entity_exit_host)

	if parent != null:
		_entity_set_owner(entity, parent)

	if entity.aspects.has(SimulationAspectType.PLAYER):
		player_entities[entity.id] = entity
	elif !entity.aspects.has(SimulationAspectType.SETTLEMENT) && entity.actor != null:
		entity.actor.modulate.a = 0

func _entity_set_owner(entity: SimulationEntity, owner_entity: SimulationEntity) -> void:
	var entity_relationships = entity.aspects.get_or_add(SimulationAspectType.RELATIONSHIPS,
		SimulationRelationshipAspect.new())
	var owner_entity_relationships = owner_entity.aspects.get_or_add(SimulationAspectType.RELATIONSHIPS,
		SimulationRelationshipAspect.new())

	entity_relationships.add(SimulationRelationshipType.OWNED_BY, owner_entity.id)
	owner_entity_relationships.add(SimulationRelationshipType.OWNER_OF, entity.id)

func _on_entity_collision(entity: SimulationEntity, other: SimulationEntity) -> void:
	if other.aspects.has(SimulationAspectType.SETTLEMENT):
		_handle_entity_entered_host(entity, other)
		if player_entities.has(entity.id):
			player_entered_settlement.emit(SettlementViewModel.new(other, _context()))

func _on_entity_sighted(entity: SimulationEntity, other: SimulationEntity) -> void:
	if player_entities.has(entity.id):
		SimulationTweens.fade_actor_in(other.actor)

func _on_entity_lost_sight(entity: SimulationEntity, other: SimulationEntity) -> void:
	if player_entities.has(entity.id) && !other.aspects.has(SimulationAspectType.SETTLEMENT):
		SimulationTweens.fade_actor_out(other.actor)

func _get_next_entity_id() -> int:
	next_entity_id += 1
	return next_entity_id - 1

func _context() -> SimulationContext:
	return SimulationContext.new(date_time, entities)

func _handle_entity_entered_host(entity: SimulationEntity, host: SimulationEntity) -> void:
	var host_aspect = host.aspects.get_or_add(SimulationAspectType.HOST, SimulationHostAspect.new())
	host_aspect.add(entity.id)
	entity.hosted_by = host.id

	var memory_aspect = host.aspects.get_or_add(SimulationAspectType.MEMORY, SimulationMemoryAspect.new())
	memory_aspect.entity_seen(entity.id, date_time)

	process_command(SimulationStopAllCommand.new(entity))
	SimulationTweens.fade_actor_out(entity.actor)

func _handle_entity_exit_host(entity: SimulationEntity) -> void:
	if entity.hosted_by != 0 && entity.hosted_by != null:
		var host_entity = entities.get(entity.hosted_by)
		var host_aspect = host_entity.aspects.get(SimulationAspectType.HOST)
		if host_aspect != null:
			host_aspect.remove(entity.id)
		entity.hosted_by = 0
		entity.actor.position = host_entity.actor.position
		entity.actor.position.y += 1
		if player_entities.has(entity.id):
			SimulationTweens.fade_actor_in(entity.actor)
