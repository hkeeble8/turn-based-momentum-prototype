class_name BrainAspect
extends RefCounted

var brain_script: Script

func think(entity: SimulationEntity) -> Array:
	return brain_script.think(entity)

func get_type() -> int:
	return Type.BRAIN
