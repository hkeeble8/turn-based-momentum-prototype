class_name SimulationV2
extends Node2D

var next_entity_id: int = 1
var day: int = 1
var steps_today: int = 1
var observers: Array[SimulationObserver]
var entities: Dictionary[int, SimulationEntityV2]

static func deserialize(data: Dictionary) -> SimulationV2:
	var simulation = SimulationV2.new()
	for entity_id in data["entities"].keys():
		var entity = SimulationEntityV2.deserialize(data["entities"].get(entity_id))
		simulation.entities[entity.id] = entity
		simulation.add_child(entity)
	return simulation

func _init() -> void:
	observers = [SimulationLogger.new()]

func _ready() -> void:
	_discover_nodes()

func get_state() -> SimulationState:
	return SimulationState.new(
		next_entity_id,
		day,
		steps_today,
		entities
	)

func step() -> void:
	for entity in entities.values():
		entity.step()

	if steps_today >= 10:
		steps_today = 1
		day += 1
	else:
		steps_today += 1

func _discover_nodes():
	for node in get_children():
		if node is SimulationEntityV2:
			var entity = node as SimulationEntityV2
			entities[entity.id] = entity
