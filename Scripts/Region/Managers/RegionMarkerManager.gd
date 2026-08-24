class_name RegionMarkerManager
extends Node

enum MarkerType {
	SETTLEMENT
}

var markers: Dictionary[int, Sprite2D]

func update_marker(
	entity_id: int,
	_type: MarkerType,
	position: Vector2i
) -> void:
	var new_marker = !markers.has(entity_id)
	
	var marker_sprite = Sprite2D.new()
	marker_sprite.texture = RegionGlobals.ASSETS.settlement_marker
	marker_sprite.position = RegionGrid.cell_to_world(position)
	markers[entity_id] = marker_sprite
	if new_marker:
		add_child(marker_sprite)

func remove_marker(entity_id: int) -> void:
	var marker = markers.get(entity_id)
	if marker != null:
		markers.erase(entity_id)
		marker.queue_free()

func hide_marker(entity_id: int) -> void:
	var marker = markers.get(entity_id)
	if marker != null:
		marker.visible = false

func show_marker(entity_id: int) -> void:
	var marker = markers.get(entity_id)
	if marker != null:
		marker.visible = true

func clear() -> void:
	NodeUtils.free_nodes(markers.values())
	markers.clear()
