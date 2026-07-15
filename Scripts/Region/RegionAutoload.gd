extends Node

func _ready() -> void:
	const region_config_path: String = "res://Resources/Region/Region Config.tres"
	RegionGlobals.CONFIG = load(region_config_path)
	if RegionGlobals.CONFIG == null:
		push_warning("Region config failed to load! It must exist at %s. 
			Defaults will be used." % region_config_path)
		RegionGlobals.CONFIG = RegionConfig.new()
