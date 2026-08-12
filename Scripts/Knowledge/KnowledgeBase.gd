class_name KnowledgeBase
extends RefCounted

var knowledge: Dictionary[int, KnowledgeSubject] = {}

func knowledge_of(subject_id: int) -> KnowledgeSubject:
    if !knowledge.has(subject_id):
        knowledge[subject_id] = KnowledgeSubject.new()
    return knowledge[subject_id]
