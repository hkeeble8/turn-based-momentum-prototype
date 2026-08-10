class_name SimulationEntity
extends Node

signal collision(entity: SimulationEntity, other: SimulationEntity)

@export var assigned_aspects: Array[SimulationAspect] = []

var id: int
var position: Vector2i
var actor: SimulationActor
var aspects: Dictionary[int, SimulationAspect] = {}

func _ready() -> void:
	_discover_nodes()
	_init_assigned_aspects()
	init_connections()
	position = actor.get_current_cell()

func init_connections() -> void:
	actor.position_changed.connect(_on_actor_position_changed)
	actor.collision.connect(_on_actor_collision)

func step(context: SimulationContext) -> Array[SimulationCommand]:
	var commands: Array[SimulationCommand] = []
	for aspect in aspects.values():
		var command = aspect.step(self, context)
		if command != null:
			commands.append(command)
	return commands

func serialize() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"position": {
			"x": position.x,
			"y": position.y
		},
		"aspects": _serialize_aspects(),
		"actor": actor.serialize()
	}

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

func _init_assigned_aspects() -> void:
	for aspect in assigned_aspects:
		aspects[aspect.get_type()] = aspect

func _discover_nodes() -> void:
	var simulation_actor: SimulationActor
	for node in get_children():
		if node is SimulationActor:
			simulation_actor = node
	actor = simulation_actor
