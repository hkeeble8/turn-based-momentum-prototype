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

func serialize_data() -> Dictionary:
	return {
		"base_color": base_color,
		"symbol": symbol
	}

static func deserialize(data: Dictionary) -> SimulationBannerAspect:
	var aspect = SimulationBannerAspect.new()
	aspect.base_color = data["base_color"]
	aspect.symbol = data["symbol"]
	return aspect

func get_colour_description() -> String:
	return BannerColour.keys()[base_color].to_lower()