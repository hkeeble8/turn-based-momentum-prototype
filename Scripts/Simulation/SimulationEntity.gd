class_name SimulationEntity
extends Node

signal commands_issued(commands: Array[SimulationCommand])

var id: int
var aspects: Dictionary[int, SimulationAspect] = {}

func _init(new_id: int, new_name: String, new_aspects: Array[SimulationAspect]) -> void:
	id = new_id
	name = new_name
	for aspect in new_aspects:
		aspects[aspect.get_type()] = aspect

func serialize() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"aspects": aspects.values().map(func(aspect): return aspect.serialize())
	}

func issue_commands(commands: Array[SimulationCommand]) -> void:
	commands_issued.emit(commands)

func get_aspect(type: int) -> SimulationAspect:
	return aspects.get(type)

func process_step() -> void:
	pass
