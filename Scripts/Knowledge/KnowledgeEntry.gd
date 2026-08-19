class_name KnowledgeEntry
extends RefCounted

var expiry_day: int
var expiry_step: int
var type: StringName
var value: Variant

func _init(
    new_expiry_day: int,
    new_expiry_step: int,
    new_type: StringName,
    new_value: Variant
) -> void:
    expiry_day = new_expiry_day
    expiry_step = new_expiry_step
    type = new_type
    value = new_value

func serialize() -> Dictionary:
    return {
        "expiry_day": expiry_day,
        "expiry_step": expiry_step,
        "type": type,
        "value": value
    }

static func deserialize(data: Dictionary) -> KnowledgeEntry:
    return KnowledgeEntry.new(
        data["expiry_day"],
        data["expiry_step"],
        data["type"],
        data["value"]
    )