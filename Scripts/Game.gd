class_name Game
extends Node

var region_scene: PackedScene = preload("res://Scenes/Region/Region.tscn")
var battle_scene: PackedScene = preload("res://Scenes/Battle/Battle.tscn")

var current_region: Region
var current_battle: Battle

func _init() -> void:
    _load_region()

func _load_region() -> void:
    var region_node = region_scene.instantiate()
    region_node.name = "Region"
    current_region = region_node
    current_region.battle_requested.connect(_on_battle_requested)
    add_child(region_node)

func _load_battle() -> void:
    var battle_node = battle_scene.instantiate()
    battle_node.name = "Battle"
    current_battle = battle_node
    current_battle.resolved.connect(_on_battle_resolved)
    add_child(battle_node)

func _on_battle_requested() -> void:
    current_region.process_mode = Node.PROCESS_MODE_DISABLED
    current_region.hide()
    _load_battle()

func _on_battle_resolved() -> void:
    current_region.process_mode = Node.PROCESS_MODE_ALWAYS
    current_region.show()
    remove_child(current_battle)