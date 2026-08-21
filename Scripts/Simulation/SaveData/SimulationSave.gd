class_name SimulationSave
extends Resource

@export var next_entity_id: int
@export var next_contract_id: int
@export var date_time: SimulationDateTime
@export var entities: Dictionary[int, SimulationEntityData]
@export var contracts: Dictionary[int, Contract]

func _init(
	p_next_entity_id: int = 1,
	p_next_contract_id: int = 1,
	p_date_time: SimulationDateTime = SimulationDateTime.new(),
	p_entities: Dictionary[int, SimulationEntity] = {},
	p_contracts: Dictionary[int, Contract] = {}
) -> void:
	next_entity_id = p_next_entity_id
	next_contract_id = p_next_contract_id
	date_time = p_date_time
	contracts = p_contracts
	entities = {}
	for entity_id in p_entities.keys():
		var entity = entities[entity_id]
		var entity_data = SimulationEntityData.new(
			entity.id,
			entity.position,
			entity.actor,
			entity.aspects,
			entity.hosted_by
		)
		entities[entity_id] = entity_data
