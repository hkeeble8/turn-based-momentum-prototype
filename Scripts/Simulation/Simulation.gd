class_name Simulation

var next_entity_id: int = 1
var day: int
var steps_today: int
var observers: Array[SimulationObserver]
var entities: Array[SimulationEntity]

func _init() -> void:
	observers = [SimulationLogger.new()]

func create_entity(name: String, definitions: Array[SimulationEntityDefinition]) -> void:
	var aspects: Array[SimulationAspect] = []
	for definition in definitions:
		aspects.append(definition.create_aspect())
	var entity = SimulationEntity.new(next_entity_id, name, aspects)
	entities.append(entity)
	next_entity_id += 1
	notify_entity_added(entity)

func step() -> void:
	if steps_today >= 10:
		steps_today = 0
		day += 1

	for entity in entities:
		entity.process_step()

func notify_entity_added(entity: SimulationEntity) -> void:
	for observer in observers:
		observer.on_entity_added(_build_context(), entity)

func _build_context() -> SimulationContext:
	return SimulationContext.new(
		day,
		steps_today
	)
