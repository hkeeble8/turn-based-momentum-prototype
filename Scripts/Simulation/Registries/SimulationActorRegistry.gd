class_name SimulationActorRegistry

static var initialized: bool = false
static var scenes: Dictionary[StringName, PackedScene]

static func initialize():
	_scan("res://Scenes/Simulation/Actors")

static func get_actor_scene(id: StringName) -> PackedScene:
	if initialized == false:
		initialize()
		initialized = true
	return scenes.get(id)

static func _scan(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		push_error("Couldn't open %s" % path)
		return

	dir.list_dir_begin()

	while true:
		var name := dir.get_next()
		if name == "":
			break

		if name.begins_with("."):
			continue

		var full_path := path.path_join(name)
		if dir.current_is_dir():
			_scan(full_path)
		elif name.ends_with(".tscn"):
			_register_scene(full_path)

	dir.list_dir_end()

static func _register_scene(path: String) -> void:
	var scene := load(path) as PackedScene
	if scene == null:
		return

	var actor := scene.instantiate() as SimulationActor
	if actor == null:
		push_error("%s is not a ActorSimulationActorScene" % path)
		return

	if actor.id == StringName():
		push_error("%s has no id" % path)
		actor.queue_free()
		return

	if scenes.has(actor.id):
		push_error("Duplicate id '%s'" % actor.id)
		actor.queue_free()
		return

	scenes[actor.id] = scene
	actor.queue_free()
