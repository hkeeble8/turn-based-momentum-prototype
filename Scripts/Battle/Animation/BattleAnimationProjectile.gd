class_name BattleAnimationProjectile
extends BattleAnimationEventScript

@export var projectile: Node2D

var speed = 150.0 # units per second

func play(context: BattleAnimationEventContext) -> void:
	var distance = projectile.global_position.distance_to(context.target_actor.global_position)
	var duration = distance / speed

	var tween1 = create_tween()
	tween1.tween_property(projectile, "global_position", context.target_actor.global_position, duration)
	tween1.tween_property(context.target_actor.get_sprite(), "modulate", Color.RED, 0.05)
	await tween1.finished

	if BattleGlobals.ASSETS.animation_attack_damage:
		AnimationUtils.play_battle_animation_event(context.target_actor, BattleGlobals.ASSETS.animation_attack_damage, context)

	var tween2 = create_tween()
	tween2.tween_property(context.target_actor.get_sprite(), "modulate", Color.WHITE, 0.05)
	await tween2.finished
