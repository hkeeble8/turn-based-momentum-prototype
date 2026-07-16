class_name SimulationContext
extends RefCounted

var day: int
var steps_today: int

func _init(new_day: int, new_steps_today: int) -> void:
    day = new_day
    new_steps_today = steps_today