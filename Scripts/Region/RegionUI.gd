extends Control
class_name RegionUI

signal attack_requested
signal leave_requested

@export var encounter_panel: Panel
@export var attack_button: Button
@export var leave_button: Button

func _ready() -> void:
	hide_encounter_panel()
	attack_button.pressed.connect(_on_attack_button_pressed)
	leave_button.pressed.connect(_on_leave_button_pressed)

func _on_attack_button_pressed() -> void:
	attack_requested.emit()

func _on_leave_button_pressed() -> void:
	leave_requested.emit()

func show_encounter_panel() -> void:
	encounter_panel.show()

func hide_encounter_panel() -> void:
	encounter_panel.hide()
