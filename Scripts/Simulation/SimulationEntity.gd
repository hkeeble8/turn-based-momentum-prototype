class_name SimulationEntity
extends Node

signal collision(entity: SimulationEntity, other: SimulationEntity)
signal sighted(entity: SimulationEntity, other: SimulationEntity)
signal lost_sight(entity: SimulationEntity, other: SimulationEntity)
signal left_host(entity: SimulationEntity)

@export var assigned_aspects: Array[SimulationAspect] = []

var id: int
var position: Vector2i
var actor: SimulationActor
var knowledge_base: KnowledgeBase = KnowledgeBase.new()
var aspects: Dictionary[StringName, SimulationAspect] = {}
var hosted_by: int

func _ready() -> void:
	_discover_nodes()
	_init_assigned_aspects()
	init_connections()
	if actor != null:
		position = actor.get_current_cell()

func init_connections() -> void:
	if actor != null:
		actor.position_changed.connect(_on_actor_position_changed)
		actor.collision.connect(_on_actor_collision)
		actor.sighted.connect(_on_actor_sighted)
		actor.lost_sight.connect(_on_actor_lost_sight)

func step(context: SimulationContext) -> Array[SimulationCommand]:
	var commands: Array[SimulationCommand] = []
	for aspect in aspects.values():
		var command = aspect.step(self, context)
		if command != null:
			commands.append(command)
	return commands

func serialize() -> Dictionary:
	var data = {
		"id": id,
		"name": name,
		"position": {
			"x": position.x,
			"y": position.y
		},
		"aspects": _serialize_aspects(),
		"hosted_by": hosted_by
	}
	if actor != null:
		data["actor"] = actor.serialize()
	return data

func set_id(new_id: int) -> void:
	id = new_id
	if actor != null:
		actor.entity_id = id

func leave_host() -> void:
	left_host.emit(self)

func _serialize_aspects() -> Dictionary:
	var result := {}
	for aspect in aspects.values():
		result[aspect.get_type()] = aspect.serialize()
	return result

func _on_actor_position_changed() -> void:
	position = actor.get_current_cell()

func _on_actor_collision(area: Area2D) -> void:
	if area.get_parent() is SimulationActor:
		collision.emit(self, area.get_parent().get_parent())

func _on_actor_sighted(area: Area2D) -> void:
	if area.get_parent() is SimulationActor:
		var sighted_entity = area.get_parent().get_parent()
		sighted.emit(self, sighted_entity)

func _on_actor_lost_sight(area: Area2D) -> void:
	if area.get_parent() is SimulationActor:
		var lost_sight_entity = area.get_parent().get_parent()
		lost_sight.emit(self, lost_sight_entity)

func _init_assigned_aspects() -> void:
	for aspect in assigned_aspects:
		aspects[aspect.get_type()] = aspect

func _discover_nodes() -> void:
	var simulation_actor: SimulationActor
	for node in get_children():
		if node is SimulationActor:
			simulation_actor = node
	if simulation_actor != null:
		actor = simulation_actor
		actor.entity_id = id
