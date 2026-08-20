class_name SimulationKnowledgeAspect
extends SimulationAspect

var knowledge: Dictionary[int, KnowledgeSubject] = {}

func get_type() -> StringName:
	return SimulationAspectType.KNOWLEDGE

func knowledge_of(subject_id: int) -> KnowledgeSubject:
	if !knowledge.has(subject_id):
		knowledge[subject_id] = KnowledgeSubject.new()
	return knowledge[subject_id]
