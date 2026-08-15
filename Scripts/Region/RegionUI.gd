extends Control
class_name RegionUI

signal pause_requested
signal continue_requested
signal save_requested
signal load_requested

signal attack_requested
signal leave_requested

enum Mode {
	DEFAULT,
	PAUSE,
	ENCOUNTER,
	SETTLEMENT
}

var mode_controls: Dictionary[Mode, Control]

@export_group("Default UI")
@export var default_control: Control
@export var pause_button: Button

@export_group("Pause UI")
@export var pause_container: Container
@export var continue_button: Button
@export var save_button: Button
@export var load_button: Button
@export var quit_button: Button

@export_group("Encounter UI")
@export var encounter_container: Container
@export var attack_button: Button
@export var leave_button: Button

@export_group("Settlement UI")
@export var settlement_container: RegionSettlementUI

func _ready() -> void:
	mode_controls = {
		Mode.DEFAULT: default_control,
		Mode.PAUSE: pause_container,
		Mode.ENCOUNTER: encounter_container,
		Mode.SETTLEMENT: settlement_container,
	}

	set_mode(Mode.DEFAULT)

	pause_button.pressed.connect(_on_pause_button_pressed)
	continue_button.pressed.connect(_on_continue_button_pressed)
	save_button.pressed.connect(_on_save_button_pressed)
	load_button.pressed.connect(_on_load_button_pressed)

	attack_button.pressed.connect(_on_attack_button_pressed)
	leave_button.pressed.connect(_on_leave_button_pressed)

func _on_pause_button_pressed() -> void:
	pause_requested.emit()

func _on_continue_button_pressed() -> void:
	continue_requested.emit()

func _on_save_button_pressed() -> void:
	save_requested.emit()

func _on_load_button_pressed() -> void:
	load_requested.emit()

func _on_attack_button_pressed() -> void:
	attack_requested.emit()
	set_mode(Mode.DEFAULT)

func _on_leave_button_pressed() -> void:
	leave_requested.emit()

func set_settlement(settlement: SimulationEntity) -> void:
	settlement_container.init_ui(settlement)
	set_mode(Mode.SETTLEMENT)

func set_mode(mode: Mode) -> void:
	for mode_key in mode_controls.keys():
		var control = mode_controls.get(mode_key)
		if mode_key == mode:
			control.show()
		else:
			control.hide()
