extends Control
class_name BattleUI

signal turn_end_requested
signal skill_selected(skill: BattleSkill)
signal skill_deselected

@export var button_turn_end: Button

@export var label_health: Label
@export var label_movement_points: Label
@export var label_action_points: Label

@export var bar_health: ProgressBar
@export var bar_movement_points: ProgressBar
@export var bar_action_points: ProgressBar

@export var skills_button_panel: Panel
@export var skills_button_container: HBoxContainer

func _ready() -> void:
	button_turn_end.pressed.connect(_on_button_turn_end_pressed)

func _on_button_turn_end_pressed() -> void:
	turn_end_requested.emit()

func _on_skill_button_toggled(toggled_on: bool, skill: BattleSkill) -> void:
	if toggled_on:
		skill_selected.emit(skill)
	else:
		skill_deselected.emit()

func set_health(maximum: int, value: int) -> void:
	label_health.text = str(value) + "/" + str(maximum)
	bar_health.step = 1
	bar_health.max_value = maximum
	bar_health.value = value

func set_movement_points(maximum: int, value: int) -> void:
	label_movement_points.text = str(value) + "/" + str(maximum)
	bar_movement_points.step = 1
	bar_movement_points.max_value = maximum
	bar_movement_points.value = value

func set_action_points(maximum: int, value: int) -> void:
	label_action_points.text = str(value) + "/" + str(maximum)
	bar_action_points.step = 1
	bar_action_points.max_value = maximum
	bar_action_points.value = value

func set_skills(skills: Array[BattleSkill], action_points_current: int) -> void:
	NodeUtils.free_nodes(skills_button_container.get_children())
	for skill in skills:
		var skill_button: Button = BattleGlobals.ASSETS.ui_skill_button.instantiate()
		skill_button.icon = skill.icon
		skill_button.tooltip_text = skill.name
		if action_points_current <= 0:
			skill_button.disabled = true
		skill_button.toggled.connect(_on_skill_button_toggled.bind(skill))
		skills_button_container.add_child(skill_button)
	skills_button_panel.show()

func show_end_turn_button() -> void:
	button_turn_end.show()

func hide_end_turn_button() -> void:
	button_turn_end.hide()

func hide_skills() -> void:
	skills_button_panel.hide()
