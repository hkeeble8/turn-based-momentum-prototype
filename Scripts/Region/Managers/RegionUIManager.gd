class_name RegionUIManager
extends Node

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
	ui.attack_requested.connect(_on_attack_requested)
	ui.leave_requested.connect(_on_leave_requested)

func show_encounter_panel() -> void:
	ui.show_encounter_panel()

func hide_encounter_panel() -> void:
	ui.hide_encounter_panel()

func _on_attack_requested() -> void:
	attack_requested.emit()

func _on_leave_requested() -> void:
	leave_requested.emit()
