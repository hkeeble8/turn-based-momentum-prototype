class_name AnimationUtils

static func create_context(source: BattleActor, target: BattleActor) -> BattleAnimationEventContext:
    var context = BattleAnimationEventContext.new()
    if source:
        context.reset_position = source.position
        context.source_actor = source
        context.source_cell = source.get_current_cell()
    if target:
        context.target_actor = target
        context.target_cell = target.get_current_cell()
        context.target_actor = target
    return context

static func play_battle_animation_event(
    parent: Node,
    animation_scene: PackedScene,
    context: BattleAnimationEventContext
):
    var battle_battle_animation_event: BattleAnimationEvent = animation_scene.instantiate() as BattleAnimationEvent
    parent.add_child(battle_battle_animation_event)
    await battle_battle_animation_event.play(context)
    parent.remove_child(battle_battle_animation_event)