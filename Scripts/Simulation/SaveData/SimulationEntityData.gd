class_name SimulationEntityData
extends Resource

@export var id: int
@export var position: Vector2i
@export var actor_id: String
@export var aspects: Dictionary[StringName, SimulationAspect] = {}
@export var hosted_by: int

func _init(
	id: int = 1,
	position: Vector2i = Vector2i.ZERO,
	actor: SimulationActor = null,
	aspects: Dictionary[StringName, SimulationAspect] = {},
	hosted_by: int = 0
) -> void:
	self.id = id
	self.position = position
	self.aspects = aspects
	self.hosted_by = hosted_by
	if actor != null:
		self.actor_id = actor.id
