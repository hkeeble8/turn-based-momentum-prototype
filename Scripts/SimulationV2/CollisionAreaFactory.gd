class_name CollisionAreaFactory

static func create(scale: float, size: Vector2) -> Area2D:
    var new_shape := RectangleShape2D.new()
    new_shape.size = size * scale

    var collision_shape = CollisionShape2D.new()
    collision_shape.shape = new_shape

    var collision_area = Area2D.new()
    collision_area.add_child(collision_shape)

    return collision_area