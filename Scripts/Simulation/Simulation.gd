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

func step() -> void:
	var context = _build_context()
	for entity in entities.values():
		_entity_think(context, entity)
		entity.process_step()

	if steps_today >= 10:
		steps_today = 1
		day += 1
	else:
		steps_today += 1

func _entity_think(context: SimulationContext, entity: SimulationEntity) -> void:
	var brain = entity.get_aspect(SimulationAspect.Type.BRAIN)
	if brain != null:
		var new_commands = brain.think(entity, context)
		_add_command_context(entity.id, new_commands)
		entity.issue_commands(new_commands)
		_notify_commands_issued(new_commands)

func _build_entity(name: String, definitions: Array[SimulationEntityDefinition]) -> SimulationEntity:
	var aspects: Array[SimulationAspect] = []
	for definition in definitions:
		aspects.append(definition.create_aspect())
	var entity = SimulationEntity.new(next_entity_id, name, aspects)
	next_entity_id += 1
	return entity

func _add_command_context(issuer_entity_id: int, commands: Array[SimulationCommand]) -> void:
	for command in commands:
		command.issuer_entity_id = issuer_entity_id
		command.day = day
		command.step = steps_today

func _notify_entity_added(entity: SimulationEntity) -> void:
	for observer in observers:
		observer.on_entity_added(_build_context(), entity)

func _notify_commands_issued(commands: Array[SimulationCommand]) -> void:
	for observer in observers:
		observer.on_commands_issued(_build_context(), commands)

func _build_context() -> SimulationContext:
	return SimulationContext.new(
		day,
		steps_today,
		entities
	)
