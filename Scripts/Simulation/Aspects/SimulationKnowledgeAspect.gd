class_name SimulationKnowledgeAspect
extends SimulationAspect

var knowledge: Dictionary[int, KnowledgeSubject] = {}

func get_type() -> StringName:
	return SimulationAspectType.KNOWLEDGE

func knowledge_of(subject_id: int) -> KnowledgeSubject:
	if !knowledge.has(subject_id):
		knowledge[subject_id] = KnowledgeSubject.new()
	return knowledge[subject_id]

func serialize_data() -> Dictionary:
	return {
		"knowledge": SerializationUtils.serialized_dictionary_entries(knowledge)
	}

static func deserialize(data: Dictionary) -> SimulationKnowledgeAspect:
	var aspect = SimulationKnowledgeAspect.new()
	aspect.knowledge = SerializationUtils.deserialized_dictionary_entries(data["knowledge"], KnowledgeSubject.deserialize)
	return aspect
