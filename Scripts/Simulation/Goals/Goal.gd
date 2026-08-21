class_name Goal
extends RefCounted

var priority: int = 0

func generate_command(_entity: SimulationEntity, _context: SimulationContext) -> SimulationCommand:
    return null