class_name KnowledgeSubject
extends RefCounted

var knowledge_entries: Dictionary[StringName, KnowledgeEntry]

func _init() -> void:
	knowledge_entries = {}

func add(
	type: String,
	value: Variant,
	date_time: SimulationDateTime
):
	knowledge_entries[type] = KnowledgeEntry.new(
		type,
		value,
		date_time
	)

func entry_for(type: String) -> KnowledgeEntry:
	return knowledge_entries.get(type)

func serialize() -> Dictionary:
	return SerializationUtils.serialized_dictionary_entries(knowledge_entries)

static func deserialize(data: Dictionary) -> KnowledgeSubject:
	var knowledge_subject = KnowledgeSubject.new()
	var dict = SerializationUtils.deserialized_dictionary_entries(data, KnowledgeEntry.deserialize)
	#knowledge_subject.knowledge_entries = SerializationUtils.deserialized_dictionary_entries(data, KnowledgeEntry.deserialize)
	return knowledge_subject
