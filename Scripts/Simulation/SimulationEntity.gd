class_name SimulationEntity
extends Node

signal command_issued(commands: SimulationCommand)

enum State {
	IDLE,
	MOVING
}

var id: int
var aspects: Dictionary[int, SimulationAspect] = {}
var state: State

func _init(new_id: int, new_name: String, new_aspects: Array[SimulationAspect]) -> void:
	id = new_id
	name = new_name
	state = State.IDLE
	for aspect in new_aspects:
		aspects[aspect.get_type()] = aspect

func serialize() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"aspects": aspects.values().map(func(aspect): return aspect.serialize())
	}

func issue_command(command: SimulationCommand) -> void:
	command_issued.emit(command)
	state = command.get_state() as State

func get_aspect(type: int) -> SimulationAspect:
	return aspects.get(type)

func process_step() -> void:
	pass
