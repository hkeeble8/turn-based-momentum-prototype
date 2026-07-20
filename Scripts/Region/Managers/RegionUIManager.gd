class_name RegionUIManager
extends Node

signal pause_requested
signal continue_requested
signal save_requested
signal load_requested

signal attack_requested
signal leave_requested

var ui_root: CanvasLayer
var ui: RegionUI

func _ready() -> void:
	ui = RegionGlobals.ASSETS.ui.instantiate()
	ui.name = "RegionUI"
	
	ui_root = CanvasLayer.new()
	ui_root.name = "RegionUI Root"
	
	add_child(ui_root)
	ui_root.add_child(ui)

	_init_connections()

func _init_connections() -> void:
	ui.pause_requested.connect(_on_pause_requested)
	ui.continue_requested.connect(_on_continue_requested)
	ui.save_requested.connect(_on_save_requested)
	ui.load_requested.connect(_on_load_requested)

	ui.attack_requested.connect(_on_attack_requested)
	ui.leave_requested.connect(_on_leave_requested)

func show_ui() -> void:
	ui_root.show()

func hide_ui() -> void:
	ui_root.hide()

func show_encounter_ui() -> void:
	ui.set_mode(RegionUI.Mode.ENCOUNTER)

func show_pause_ui() -> void:
	ui.set_mode(RegionUI.Mode.PAUSE)

func show_default_ui() -> void:
	ui.set_mode(RegionUI.Mode.DEFAULT)

func _on_pause_requested() -> void:
	pause_requested.emit()

func _on_continue_requested() -> void:
	continue_requested.emit()

func _on_save_requested() -> void:
	save_requested.emit()

func _on_load_requested() -> void:
	load_requested.emit()

func _on_attack_requested() -> void:
	attack_requested.emit()

func _on_leave_requested() -> void:
	leave_requested.emit()
