class_name KnowledgeSubject
extends RefCounted

var knowledge_entries: Dictionary[StringName, KnowledgeEntry]

func _init() -> void:
    knowledge_entries = {}

func add(
    type: String,
    value: Variant,
    expiry_day: int,
    expiry_step: int
):
    knowledge_entries[type] = KnowledgeEntry.new(
        expiry_day,
        expiry_step,
        type,
        value
    )

func entry_for(type: String) -> Variant:
    if knowledge_entries.has(type):
        return knowledge_entries[type].value
    return null