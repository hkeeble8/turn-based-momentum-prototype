class_name BattleIndicatorManager
extends Node

var ground_indicator_container_node: Node2D
var turn_indicator_node: Node2D
var cell_select_indicator_node: Node2D
var path_indicator_node: Node2D
var cell_move_indicator_node: Node2D
var cell_attack_indicator_node: Node2D

func _ready() -> void:
	ground_indicator_container_node = Node2D.new()
	ground_indicator_container_node.name = "Ground Indicator Container"
	get_parent().add_child(ground_indicator_container_node)

	cell_select_indicator_node = BattleGlobals.ASSETS.indicator_cell_select.instantiate()
	cell_select_indicator_node.name = "Cell Select Indicator"
	cell_select_indicator_node.visible = false
	ground_indicator_container_node.add_child(cell_select_indicator_node)
	
	cell_move_indicator_node = Node2D.new()
	cell_move_indicator_node.name = "Cell Move Indicator Node"
	ground_indicator_container_node.add_child(cell_move_indicator_node)

	cell_attack_indicator_node = Node2D.new()
	cell_attack_indicator_node.name = "Cell Attack Indicator Node"
	ground_indicator_container_node.add_child(cell_attack_indicator_node)

	path_indicator_node = Node2D.new()
	path_indicator_node.name = "Path Indicator"
	ground_indicator_container_node.add_child(path_indicator_node)

	turn_indicator_node = BattleGlobals.ASSETS.indicator_turn.instantiate()
	turn_indicator_node.name = "Turn Indicator"
	turn_indicator_node.position += Vector2(0, -BattleGlobals.CELL_SIZE)

func move_turn_indicator(actor: BattleActor) -> void:
	NodeUtils.remove_from_parent(turn_indicator_node)
	actor.add_child(turn_indicator_node)

func move_cell_indicator(cell: Vector2i) -> void:
	cell_select_indicator_node.position = BattleGrid.cell_to_world(cell)
	cell_select_indicator_node.visible = true

func hide_cell_select_indicator() -> void:
	cell_select_indicator_node.visible = false

func set_path_indicators(cells: Array[Vector2i]) -> void:
	clear_path_indicators()
	for cell in cells:
		var path_cell_indicator: Node2D = BattleGlobals.ASSETS.indicator_path.instantiate()
		path_cell_indicator.position = BattleGrid.cell_to_world(cell)
		path_cell_indicator.name = "Path Indicator %s,%s" % [cell.x, cell.y]
		path_indicator_node.add_child(path_cell_indicator)

func set_cell_move_indicators(cells: Array[Vector2i]) -> void:
	clear_cell_move_indicators()
	for cell in cells:
		var cell_move_indicator: Node2D = BattleGlobals.ASSETS.indicator_move.instantiate()
		cell_move_indicator.position = BattleGrid.cell_to_world(cell)
		cell_move_indicator.name = "Cell Move Indicator %s,%s" % [cell.x, cell.y]
		cell_move_indicator_node.add_child(cell_move_indicator)

func set_cell_attack_indicators(cells: Array[Vector2i]) -> void:
	clear_cell_attack_indicators()
	for cell in cells:
		var cell_attack_indicator: Node2D = BattleGlobals.ASSETS.indicator_attack.instantiate()
		cell_attack_indicator.position = BattleGrid.cell_to_world(cell)
		cell_attack_indicator.name = "Cell Attack Indicator %s,%s" % [cell.x, cell.y]
		cell_attack_indicator_node.add_child(cell_attack_indicator)

func init_for_turn(actor: BattleActor, reachable_cells: Array[Vector2i]) -> void:
	NodeUtils.remove_from_parent(turn_indicator_node)
	actor.add_child(turn_indicator_node)

	clear_cell_attack_indicators()
	if actor.is_player_controlled:
		set_cell_move_indicators(reachable_cells)
	else:
		clear_cell_move_indicators()

func clear_path_indicators() -> void:
	NodeUtils.free_nodes(path_indicator_node.get_children())

func clear_cell_move_indicators() -> void:
	NodeUtils.free_nodes(cell_move_indicator_node.get_children())

func clear_cell_attack_indicators() -> void:
	NodeUtils.free_nodes(cell_attack_indicator_node.get_children())
