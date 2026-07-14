extends Node

func _ready() -> void:
	const battle_config_path: String = "res://Resources/Battle/Battle Config.tres"
	const battle_assets_path: String = "res://Resources/Battle/Battle Assets.tres"
	BattleGlobals.CONFIG = load(battle_config_path)
	BattleGlobals.ASSETS = load(battle_assets_path)
	if BattleGlobals.CONFIG == null:
		push_warning("Battle config failed to load! It must exist at %s. 
			Defaults will be used." % battle_config_path)
		BattleGlobals.CONFIG = BattleConfig.new()
