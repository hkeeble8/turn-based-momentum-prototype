class_name SimulationEntityData
extends Resource

@export var id: int
@export var position: Vector2i
@export var actor_id: String
@export var aspects: Dictionary[StringName, SimulationAspect] = {}
@export var hosted_by: int

func _init(
	p_id: int = 1,
	p_position: Vector2i = Vector2i.ZERO,
	p_actor: SimulationActor = null,
	p_aspects: Dictionary[StringName, SimulationAspect] = {},
	p_hosted_by: int = 0
) -> void:
	id = p_id
	position = p_position
	aspects = p_aspects
	hosted_by = p_hosted_by
	if p_actor != null:
		actor_id = p_actor.id
