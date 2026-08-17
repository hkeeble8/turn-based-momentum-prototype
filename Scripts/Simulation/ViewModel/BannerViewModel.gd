class_name BannerViewModel
extends RefCounted

var banner_color: String
var banner_symbol: String
var banner_description: String

func _init(
    entity: SimulationEntity,
	_context: SimulationContext
) -> void:
    var banner_aspect: SimulationBannerAspect = entity.aspects.get(SimulationAspectType.BANNER)
    banner_color = str(banner_aspect.get_colour_description())
    banner_symbol = banner_aspect.symbol
    banner_description = "%s banner with a %s at the center" % [banner_color, banner_symbol]
