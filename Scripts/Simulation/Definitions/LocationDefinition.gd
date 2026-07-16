class_name LocationDefinition
extends SimulationEntityDefinition

@export var id: String
@export var name: String

func create_aspect() -> SimulationLocationAspect:
    var aspect = SimulationLocationAspect.new()
    aspect.id = id
    aspect.name = name
    return aspect