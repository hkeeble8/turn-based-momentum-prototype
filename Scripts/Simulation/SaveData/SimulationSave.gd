class_name SimulationSave
extends Resource

@export var next_entity_id: int
@export var next_contract_id: int
@export var date_time: SimulationDateTime
@export var entities: Dictionary[int, SimulationEntityData]
@export var contracts: Dictionary[int, Contract]

func _init(
	next_entity_id: int = 1,
	next_contract_id: int = 1,
	date_time: SimulationDateTime = SimulationDateTime.new(),
	entities: Dictionary[int, SimulationEntity] = {},
	contracts: Dictionary[int, Contract] = {}
) -> void:
	self.next_entity_id = next_entity_id
	self.next_contract_id = next_contract_id
	self.date_time = date_time
	self.contracts = contracts
	self.entities = {}
	for entity_id in entities.keys():
		var entity = entities[entity_id]
		var entity_data = SimulationEntityData.new(
			entity.id,
			entity.position,
			entity.actor,
			entity.aspects,
			entity.hosted_by
		)
		self.entities[entity_id] = entity_data
