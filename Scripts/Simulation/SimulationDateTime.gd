class_name SimulationDateTime
extends RefCounted

var day: int = 1
var steps_today: int = 1
var month: int = 1
var year: int = 348

func _init(
	new_day: int,
	new_steps_today: int,
	new_month: int,
	new_year: int
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

func duplicate() -> SimulationDateTime:
	return SimulationDateTime.new(
		day,
		steps_today,
		month,
		year
	)

func serialize() -> Dictionary:
	return {
		"day": day,
		"steps_today": steps_today,
		"month": month,
		"year": year
	}

static func deserialize(data: Dictionary) -> SimulationDateTime:
	return SimulationDateTime.new(
		data["day"],
		data["steps_today"],
		data["month"],
		data["year"]
	)