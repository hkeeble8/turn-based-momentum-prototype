class_name SimulationEntity
extends RefCounted

var aspects: Dictionary[int, SimulationAspect] = {}

func _init(new_aspects: Array[SimulationAspect]) -> void:
	for aspect in new_aspects:
		aspects[aspect.get_type()] = aspect

func process_step() -> void:
	pass
