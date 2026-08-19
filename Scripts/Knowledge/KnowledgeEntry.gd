class_name KnowledgeEntry
extends RefCounted

var type: StringName
var value: Variant
var date_time: SimulationDateTime

func _init(
    new_type: StringName,
    new_value: Variant,
    new_date_time: SimulationDateTime
) -> void:
    type = new_type
    value = new_value
    date_time = new_date_time

func serialize() -> Dictionary:
    return {
        "type": type,
        "value": value,
        "date_time": date_time.serialize()
    }

static func deserialize(data: Dictionary) -> KnowledgeEntry:
    return KnowledgeEntry.new(
        data["type"],
        data["value"],
        SimulationDateTime.deserialize(data["date_time"])
    )