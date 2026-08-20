class_name SimulationContractsAspect
extends SimulationAspect

@export var contract_ids: Array[int] = []

func add_contract(contract_id: int) -> void:
    contract_ids.append(contract_id)

func get_contracts(context: SimulationContext, status: Contract.Status) -> Array[Contract]:
    var result: Array[Contract] = []
    for contract_id in contract_ids:
        var contract = context.contracts.get(contract_id)
        if contract != null and contract.status == status:
            result.append(contract)
    return result