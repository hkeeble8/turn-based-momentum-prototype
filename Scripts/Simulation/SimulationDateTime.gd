class_name SimulationDateTime
extends Resource

@export var day: int = 1
@export var steps_today: int = 1
@export var month: int = 1
@export var year: int = 348

func _init(
	new_day: int = 1,
	new_steps_today: int = 1,
	new_month: int = 1,
	new_year: int = 1
) -> void:
	day = new_day
	steps_today = new_steps_today
	month = new_month
	year = new_year

func step() -> void:
	if steps_today >= 10:
		steps_today = 1
		day += 1
	else:
		steps_today += 1

func serialize() -> Dictionary:
	return {
		"day": day,
		"steps_today": steps_today,
		"month": month,
		"year": year
	}

static func deserialize(data: Dictionary) -> SimulationDateTime:
	return SimulationDateTime.new(
		int(data["day"]),
		int(data["steps_today"]),
		int(data["month"]),
		int(data["year"])
	)
