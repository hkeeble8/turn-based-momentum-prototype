extends Node

func _ready() -> void:
	const battle_config_path: String = "res://Resources/Battle/Battle Config.tres"
	const battle_assets_path: String = "res://Resources/Battle/Battle Assets.tres"
	const region_config_path: String = "res://Resources/Region/Region Config.tres"

	BattleGlobals.CONFIG = load(battle_config_path)
	RegionGlobals.CONFIG = load(region_config_path)

	BattleGlobals.ASSETS = load(battle_assets_path)

	if BattleGlobals.CONFIG == null:
		push_warning("Battle config failed to load! It must exist at %s. 
			Defaults will be used." % battle_config_path)
		BattleGlobals.CONFIG = BattleConfig.new()
	if RegionGlobals.CONFIG == null:
		push_warning("Region config failed to load! It must exist at %s. 
			Defaults will be used." % region_config_path)
		RegionGlobals.CONFIG = RegionConfig.new()
