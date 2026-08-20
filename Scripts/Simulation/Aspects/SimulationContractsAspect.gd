class_name SimulationContractsAspect
extends SimulationAspect

@export var contract_ids: Array[int] = []

func add_contract(contract_id: int) -> void:
    contract_ids.append(contract_id)

func get_accepted_contracts(context: SimulationContext, contractor_id: int) -> Array[Contract]:
    return _scan(context,
            func(contract):
               return contract.contractor_id == contractor_id \
                and contract.status == Contract.Status.ACCEPTED
    )

func get_available_issued_contracts(context: SimulationContext, issuer_id: int) -> Array[Contract]:
    return _scan(context,
        func(contract):
            return contract.issuer_id == issuer_id \
                 and contract.status == Contract.Status.AVAILABLE
    )

func _scan(context: SimulationContext, criteria: Callable) -> Array[Contract]:
    var result: Array[Contract] = []
    for contract_id in contract_ids:
        var contract = context.contracts.get(contract_id)
        if contract != null && criteria.call(contract):
            result.append(contract)
    return result
