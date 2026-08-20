class_name SimulationBannerAspect
extends SimulationAspect

enum BannerColour {
	RED = 0,
	BLUE = 1,
	GREEN = 2,
	YELLOW = 3,
	WHITE = 4,
	BLACK = 5,
}

@export var base_color: BannerColour
@export var symbol: String

func get_type() -> StringName:
	return SimulationAspectType.BANNER

func get_colour_description() -> String:
	return BannerColour.keys()[base_color].to_lower()