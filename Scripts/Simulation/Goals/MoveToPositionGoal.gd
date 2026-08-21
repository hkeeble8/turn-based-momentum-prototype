class_name MoveToPositionGoal
extends Goal

var position: Vector2i
	
func generate_command(entity: SimulationEntity, _context: SimulationContext) -> SimulationCommand:
    if entity.hosted_by != 0:
        return SimulationLeaveHostCommand.new(entity)
    return SimulationMoveCommand.new(entity, position)