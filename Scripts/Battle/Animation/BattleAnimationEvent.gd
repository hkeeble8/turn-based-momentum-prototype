class_name BattleAnimationEvent
extends Node2D

@export var battle_animation_event_script: BattleAnimationEventScript

func play(context: BattleAnimationEventContext) -> void:
	await battle_animation_event_script.play(context)
