class_name Simulation

var next_entity_id: int = 1
var day: int = 1
var steps_today: int = 1
var observers: Array[SimulationObserver]
var entities: Dictionary[int, SimulationEntity]

func _init() -> void:
	observers = [SimulationLogger.new()]

func add_entity(name: String, definitions: Array[SimulationEntityDefinition]) -> SimulationEntity:
	var entity = _build_entity(name, definitions)
	entities[entity.id] = entity
	_notify_entity_added(entity)
	return entity

func reset_entity_state(entity_id: int) -> void:
	entities.get(entity_id).state = SimulationEntity.State.IDLE

func step() -> void:
	for entity in entities.values():
		_entity_step(entity)

	if steps_today >= 10:
		steps_today = 1
		day += 1
	else:
		steps_today += 1

func _entity_step(entity: SimulationEntity) -> void:
	var context = _build_context()
	var command = _entity_think(context, entity)
	if command != null:
		entity.issue_command(command)
		_notify_command_issued(command)
	entity.process_step()

func _entity_think(context: SimulationContext, entity: SimulationEntity) -> SimulationCommand:
	var brain = entity.get_aspect(SimulationAspect.Type.BRAIN)
	if brain != null:
		var command = brain.think(entity, context)
		if command != null:
			_add_command_context(entity.id, command)
			return command
	return null

func _build_entity(name: String, definitions: Array[SimulationEntityDefinition]) -> SimulationEntity:
	var aspects: Array[SimulationAspect] = []
	for definition in definitions:
		aspects.append(definition.create_aspect())
	var entity = SimulationEntity.new(next_entity_id, name, aspects)
	next_entity_id += 1
	return entity

func _add_command_context(issuer_entity_id: int, command: SimulationCommand) -> void:
	command.issuer_entity_id = issuer_entity_id
	command.day = day
	command.step = steps_today

func _notify_entity_added(entity: SimulationEntity) -> void:
	for observer in observers:
		observer.on_entity_added(_build_context(), entity)

func _notify_command_issued(command: SimulationCommand) -> void:
	for observer in observers:
		observer.on_command_issued(_build_context(), command)

func _build_context() -> SimulationContext:
	return SimulationContext.new(
		day,
		steps_today,
		entities
	)
