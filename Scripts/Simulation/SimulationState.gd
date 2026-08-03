class_name SimulationState

const NEXT_ENTITY_ID_KEY = "next_entity_id"
const DAY_KEY = "day"
const STEPS_TODAY_KEY = "steps_today"
const ENTITIES_KEY = "entities"

var next_entity_id: int
var day: int
var steps_today: int
var entities: Dictionary[int, SimulationEntity]

func _init(
    new_next_entity_id: int,
    new_day: int,
    new_steps_today: int,
    new_entities: Dictionary[int, SimulationEntity]
) -> void:
    next_entity_id = new_next_entity_id
    day = new_day
    steps_today = new_steps_today
    entities = new_entities

func serialize() -> Dictionary:
    var serialized_entities = {}
    for entity_id in entities.keys():
        serialized_entities[entity_id] = entities.get(entity_id).serialize()

    return {
        NEXT_ENTITY_ID_KEY: next_entity_id,
        DAY_KEY: day,
        STEPS_TODAY_KEY: steps_today,
        ENTITIES_KEY: serialized_entities
    }

static func deserialize(json: String) -> SimulationState:
    var dict = JSON.parse_string(json)
    return SimulationState.new(
        dict[NEXT_ENTITY_ID_KEY],
        dict[DAY_KEY],
        dict[STEPS_TODAY_KEY],
        dict[ENTITIES_KEY]
    )