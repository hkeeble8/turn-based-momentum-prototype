class_name RegionUIManager
extends Node

var ui_root: CanvasLayer
var ui: RegionUI

func _ready() -> void:
	ui = RegionGlobals.ASSETS.ui.instantiate()
	ui.name = "RegionUI"
	
	ui_root = CanvasLayer.new()
	ui_root.name = "RegionUI Root"
	
	add_child(ui_root)
	ui_root.add_child(ui)

func set_settlement(settlement: SimulationEntity) -> void:
	ui.set_settlement(settlement)

func set_mode(mode: RegionUI.Mode) -> void:
	ui.set_mode(mode)

func show_ui() -> void:
	ui_root.show()

func hide_ui() -> void:
	ui_root.hide()
