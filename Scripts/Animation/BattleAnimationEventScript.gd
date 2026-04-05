class_name BattleAnimationEventScript
extends Node

func play(_context: BattleAnimationEventContext) -> void:
	# no-op, just so the compiler knows it's async
	await get_tree().process_frame
