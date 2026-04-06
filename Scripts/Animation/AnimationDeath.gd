class_name AnimationDeath
extends BattleAnimationEventScript

@onready var blood = $Blood 

func play(context: BattleAnimationEventContext) -> void:
	var tween = create_tween()
	tween.tween_property(context.target_actor.get_sprite(), "modulate", Color(0.3, 0.3, 0.3), 1)
	tween.tween_property(blood, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1)
	await tween.finished
