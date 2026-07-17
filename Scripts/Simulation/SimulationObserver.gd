class_name SimulationObserver
extends RefCounted

func on_entity_added(_context: SimulationContext, _entity: SimulationEntity) -> void:
	pass

func on_commands_issued(_context: SimulationContext, _commands: Array[SimulationCommand]) -> void:
	pass
