class_name AnimationDeath
extends BattleAnimationEventScript

func play(context: BattleAnimationEventContext) -> void:
	var tween = create_tween()
	tween.tween_property(context.target_actor.get_sprite(), "modulate", Color(0.3, 0.3, 0.3), 1)
	await tween.finished
