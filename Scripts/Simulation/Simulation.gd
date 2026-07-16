class_name Simulation

var next_entity_id: int = 1
var day: int = 1
var steps_today: int = 1
var observers: Array[SimulationObserver]
var entities: Array[SimulationEntity]
var queued_commands: Array[SimulationCommand]

func _init() -> void:
	observers = [SimulationLogger.new()]

func create_entity(name: String, definitions: Array[SimulationEntityDefinition]) -> void:
	var aspects: Array[SimulationAspect] = []
	for definition in definitions:
		aspects.append(definition.create_aspect())
	var entity = SimulationEntity.new(next_entity_id, name, aspects)
	entities.append(entity)
	next_entity_id += 1
	_notify_entity_added(entity)

func step() -> void:
	var context = _build_context()
	var commands: Array[SimulationCommand] = []
	for entity in entities:
		var brain = entity.get_aspect(SimulationAspect.Type.BRAIN)
		if brain != null:
			commands.append_array(brain.think(entity, context))
		entity.process_step()

	_enqueue_commands(commands)

	if steps_today >= 10:
		steps_today = 1
		day += 1
	else:
		steps_today += 1

func _notify_entity_added(entity: SimulationEntity) -> void:
	for observer in observers:
		observer.on_entity_added(_build_context(), entity)

func _notify_commands_enqueued(commands: Array[SimulationCommand]) -> void:
	for observer in observers:
		observer.on_commands_enqueued(_build_context(), commands)

func _enqueue_commands(commands: Array[SimulationCommand]):
	for command in commands:
		command.day = day
		command.step = steps_today
	queued_commands.append_array(commands)
	_notify_commands_enqueued(commands)

func _build_context() -> SimulationContext:
	return SimulationContext.new(
		day,
		steps_today,
		entities
	)
