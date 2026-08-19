class_name SimulationState

const NEXT_ENTITY_ID_KEY = "next_entity_id"
const DATE_TIME_KEY = "date_time"
const ENTITIES_KEY = "entities"

var next_entity_id: int
var date_time: SimulationDateTime
var entities: Dictionary[int, SimulationEntity]

func _init(
	new_next_entity_id: int,
	new_date_time: SimulationDateTime,
	new_entities: Dictionary[int, SimulationEntity]
) -> void:
	next_entity_id = new_next_entity_id
	date_time = new_date_time
	entities = new_entities

func serialize() -> Dictionary:
	var serialized_entities = {}
	for entity_id in entities.keys():
		serialized_entities[entity_id] = entities.get(entity_id).serialize()

	return {
		NEXT_ENTITY_ID_KEY: next_entity_id,
		DATE_TIME_KEY: date_time.serialize(),
		ENTITIES_KEY: serialized_entities
	}

static func deserialize(json: String) -> SimulationState:
	var dict = JSON.parse_string(json)
	return SimulationState.new(
		dict[NEXT_ENTITY_ID_KEY],
		SimulationDateTime.deserialize(dict[DATE_TIME_KEY]),
		dict[ENTITIES_KEY]
	)
