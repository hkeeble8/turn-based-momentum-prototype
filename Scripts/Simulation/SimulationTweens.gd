class_name SimulationTweens

static func fade_actor_in(actor: SimulationActor) -> void:
	var tween = actor.create_tween()
	tween.tween_property(actor, "modulate:a", 1.0, 0.5)

static func fade_actor_out(actor: SimulationActor) -> void:
	var tween = actor.create_tween()
	tween.tween_property(actor, "modulate:a", 0.0, 0.5)
