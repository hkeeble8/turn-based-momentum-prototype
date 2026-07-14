class_name AnimationAttackDamage
extends BattleAnimationEventScript

@export var damage_label: Label
@export var animation_player: AnimationPlayer

func play(context: BattleAnimationEventContext) -> void:
	damage_label.text = context.value
	animation_player.play("main")
	await animation_player.animation_finished
