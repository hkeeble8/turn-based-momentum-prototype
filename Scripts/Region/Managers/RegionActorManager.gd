class_name RegionActorManager
extends Node

signal actor_position_changed(actor: RegionActor)
signal actor_collision(actor: RegionActor, subject_actor: RegionActor)
signal actor_became_available(actor: RegionActor)

var world: World2D
var actors: Array[RegionActor] = []
var actor_selectors: Dictionary[Area2D, RegionActor] = {}
var actor_followers: Dictionary[RegionActor, Array] = {}

func _init(new_world: World2D) -> void:
	world = new_world

func register_actor(actor: RegionActor) -> void:
	actors.append(actor)
	for collision_shape in actor.collision_shapes:
		actor_selectors[collision_shape] = actor
	actor.position_changed.connect(_on_actor_position_changed)
	actor.collision.connect(_on_actor_collision)
	actor.became_available.connect(_on_actor_became_available)

func select_actor_at(position: Vector2i) -> RegionActor:
	var query := PhysicsPointQueryParameters2D.new()
	query.position = position
	query.collide_with_areas = true
	query.collision_mask = RegionGlobals.ACTOR_SELECT_LAYER

	var hits = world.direct_space_state.intersect_point(query, 1)
	if hits.is_empty():
		return null
	return actor_selectors.get(hits[0]["collider"])

func add_follower(target: RegionActor, follower: RegionActor) -> void:
	actor_followers.get_or_add(target, []).append(follower)

func get_followers(actor: RegionActor) -> Array:
	return actor_followers.get_or_add(actor, [])

func _on_actor_position_changed(actor: RegionActor) -> void:
	actor_position_changed.emit(actor)

func _on_actor_collision(actor: RegionActor, subject: Area2D) -> void:
	var subject_actor = actor_selectors.get(subject)
	actor_collision.emit(actor, subject_actor)

func _on_actor_became_available(actor: RegionActor) -> void:
	actor_became_available.emit(actor)
