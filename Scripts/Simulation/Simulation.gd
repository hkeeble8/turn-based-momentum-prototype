class_name Simulation

var day: int
var steps_today: int
var entities: Array[SimulationEntity]

func create_entity(definitions: Array[SimulationEntityDefinition]) -> void:
	var aspects: Array[SimulationAspect] = []
	for definition in definitions:
		aspects.append(definition.create_aspect())
	entities.append(SimulationEntity.new(aspects))

func _process_step() -> void:
	if steps_today >= 10:
		steps_today = 0
		day += 1

	for entity in entities:
		entity.process_step()
