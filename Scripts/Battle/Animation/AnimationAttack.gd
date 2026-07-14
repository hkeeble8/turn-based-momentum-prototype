class_name AnimationAttack
extends BattleAnimationEventScript

func play(context: BattleAnimationEventContext) -> void:
	var dir = BattleGrid.direction(context.source_cell, context.target_cell)
	
	var tween = create_tween()
	tween.tween_property(context.source_actor, "position", context.reset_position + dir * 10, 0.08)
	tween.tween_property(context.target_actor.get_sprite(), "modulate", Color.RED, 0.05)
	if BattleGlobals.ASSETS.animation_attack_damage:
		AnimationUtils.play_battle_animation_event(context.target_actor, BattleGlobals.ASSETS.animation_attack_damage, context)
	tween.tween_property(context.source_actor, "position", context.reset_position, 0.08)
	tween.tween_property(context.target_actor.get_sprite(), "modulate", Color.WHITE, 0.05)
	await tween.finished
