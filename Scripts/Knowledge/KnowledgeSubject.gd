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

func entry_for(type: String) -> KnowledgeEntry:
    return knowledge_entries.get(type)

func serialize() -> Dictionary:
    return SerializationUtils.serialized_dictionary_entries(knowledge_entries)