class_name RegionUIManager
extends Node

signal accept_contract_requested()
signal leave_requested()
signal pause_requested()

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

func set_settlement(settlement: SettlementViewModel) -> void:
	ui.set_settlement(settlement)

func set_mode(mode: RegionUI.Mode) -> void:
	ui.set_mode(mode)

func show_ui() -> void:
	ui_root.show()

func hide_ui() -> void:
	ui_root.hide()

func _init_connections() -> void:
	ui.accept_contract_requested.connect(_on_accept_contract_requested)
	ui.pause_requested.connect(_on_pause_requested)
	ui.leave_requested.connect(_on_leave_requested)

func _on_accept_contract_requested(contract_id: int) -> void:
	accept_contract_requested.emit(contract_id)

func _on_pause_requested() -> void:
	pause_requested.emit()

func _on_leave_requested() -> void:
	leave_requested.emit()
