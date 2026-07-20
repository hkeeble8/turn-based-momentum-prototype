class_name BattleUIManager
extends Node

signal turn_end_requested
signal skill_selected(skill: BattleSkill)
signal skill_deselected

var ui_root: CanvasLayer
var ui: BattleUI

func _ready() -> void:
	ui = BattleGlobals.ASSETS.ui.instantiate()
	ui.name = "BattleUI"
	
	ui.turn_end_requested.connect(_on_turn_end_requested)
	ui.skill_selected.connect(_on_skill_selected)
	ui.skill_deselected.connect(_on_skill_deselected)

	ui_root = CanvasLayer.new()
	ui_root.name = "BattleUI Root"
	
	add_child(ui_root)
	ui_root.add_child(ui)

func show_ui() -> void:
	ui_root.show()

func hide_ui() -> void:
	ui_root.hide()

func _on_turn_end_requested() -> void:
	turn_end_requested.emit()

func _on_skill_selected(skill: BattleSkill) -> void:
	skill_selected.emit(skill)

func _on_skill_deselected() -> void:
	skill_deselected.emit()

func update_hud(actor: BattleActor) -> void:
	ui.set_guard(actor.data.guard_max, actor.guard_current)
	ui.set_momentum(actor.data.momentum_max, actor.momentum_current)
	ui.set_movement_points(actor.data.movement_points_max, actor.movement_points_current)
	ui.set_action_points(actor.data.action_points_max, actor.action_points_current)
	if actor.is_player_controlled:
		ui.set_skills(actor.skills, actor.action_points_current)
		ui.show_end_turn_button()
	else:
		ui.hide_skills()
		ui.hide_end_turn_button()
