class_name KnowledgeViewModel
extends RefCounted

var knowledges: Array[String]

func _init(
	entity: SimulationEntity,
	_context: SimulationContext
) -> void:
	var knowledge_aspect: SimulationKnowledgeAspect = entity.aspects.get(SimulationAspectType.KNOWLEDGE)
	for entity_id in knowledge_aspect.knowledge.keys():
		var knowledge_subject = knowledge_aspect.knowledge_of(entity_id)
		if knowledge_subject.entry_for(KnowledgeType.SIGHTING) != null:
			knowledges.append("%s were seen passing through here." % _context.entities.get(entity_id).name)
