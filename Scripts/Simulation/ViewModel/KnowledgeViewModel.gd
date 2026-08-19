class_name KnowledgeViewModel
extends RefCounted

var knowledges: Array[String]

func _init(
	entity: SimulationEntity,
	context: SimulationContext
) -> void:
	var knowledge_aspect: SimulationKnowledgeAspect = entity.aspects.get(SimulationAspectType.KNOWLEDGE)
	for entity_id in knowledge_aspect.knowledge.keys():
		var knowledge_subject = knowledge_aspect.knowledge_of(entity_id)
		var sighting = knowledge_subject.entry_for(KnowledgeType.SIGHTING)
		if sighting != null:
			if context.date_time.day - sighting.date_time.day == 0:
				knowledges.append("%s were seen here today."
			 	% context.entities.get(entity_id).name)
			else:
				knowledges.append("%s were seen here %s days ago."
			 	% [context.entities.get(entity_id).name, context.date_time.day - sighting.date_time.day])
