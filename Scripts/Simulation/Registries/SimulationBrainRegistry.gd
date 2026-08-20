class_name SimulationBrainRegistry

static var initialized: bool = false
static var brains: Dictionary[StringName, SimulationBrain]

static func initialize():
	_scan("res://Resources/Simulation/Brains")

static func get_actor_brain(id: StringName) -> Resource:
	if initialized == false:
		initialize()
		initialized = true
	return brains.get(id)

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
		elif name.ends_with(".tres"):
			_register_brain(full_path)

	dir.list_dir_end()

static func _register_brain(path: String) -> void:
	var brain := load(path) as SimulationBrain
	if brain == null:
		return

	if brain.id == StringName():
		push_error("%s has no id" % path)
		return

	if brains.has(brain.id):
		push_error("Duplicate id '%s'" % brain.id)
		return

	brains[brain.id] = brain
