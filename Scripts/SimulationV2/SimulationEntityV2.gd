class_name SimulationEntityV2
extends Node

var id: int
var position: Vector2i
var actor: SimulationActor
@export var aspects: Array[SimulationAspect] = []

func _ready() -> void:
	_discover_nodes()
	position = actor.position

func step() -> void:
	pass

func serialize() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"position": {
			"x": position.x,
			"y": position.y
		},
		"aspects": aspects.map(func(aspect): return aspect.serialize()),
		"actor": actor.serialize()
	}

static func deserialize(data: Dictionary) -> SimulationEntityV2:
	var entity = SimulationEntityV2.new()
	entity.id = data["id"]
	entity.id = data["name"]

	entity.position = Vector2i(
		data["position"]["x"],
		data["position"]["y"]
	)
	for aspect in data["aspects"]:
		entity.aspects.append(AspectFactory.deserialize(aspect))

	entity.actor = SimulationActor.deserialize(data["actor"])
	entity.actor.position = entity.position
	entity.add_child(entity.actor)
	return entity

func _discover_nodes() -> void:
	var simulation_actor: SimulationActor
	for node in get_children():
		if node is SimulationActor:
			simulation_actor = node
	actor = simulation_actor
