class_name NodeUtils

static func remove_from_parent(node: Node) -> void:
    if node.get_parent():
        node.get_parent().remove_child(node)

static func free_nodes(nodes: Array[Node]) -> void:
    for node in nodes:
        if is_instance_valid(node):
            node.queue_free()
