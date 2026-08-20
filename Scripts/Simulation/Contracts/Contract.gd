class_name Contract
extends Resource

enum Status {
    AVAILABLE,
    ACCEPTED,
    COMPLETED
}

@export var id: int
@export var target_id: int
@export var description: String

@export var status: Status = Status.AVAILABLE
@export var contractor_id: int = -1