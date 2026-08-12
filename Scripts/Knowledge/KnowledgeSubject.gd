class_name KnowledgeSubject
extends RefCounted

var subject_id: int
var knowledge_entries: Dictionary[StringName, KnowledgeEntry]

func _init(new_subject_id: int) -> void:
    subject_id = new_subject_id
    knowledge_entries = {}

func entry_for(type: String) -> Variant:
    if knowledge_entries.has(type):
        return knowledge_entries[type].value
    return null