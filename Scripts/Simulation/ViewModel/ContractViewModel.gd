class_name ContractViewModel
extends RefCounted

var id: int
var description: String

func _init(p_contract: Contract) -> void:
    id = p_contract.id
    description = p_contract.description
