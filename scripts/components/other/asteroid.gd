@tool
class_name Asteroid
extends RigidBody2D

## How big is the asteroid?
@export_range(0.1, 2, 0.1) var size: float = 1.0:
	set = _set_size

## Use this to tint the asteroid a different color.
@export var tint: Color = Color.WHITE:
	set = _set_tint

@onready var _sprite: Sprite2D = %Sprite2D
@onready var _polygon: CollisionPolygon2D = %CollisionPolygon2D


func _ready():
	_set_tint(tint)


func _set_size(new_size: float):
	size = new_size
	if _sprite == null or _polygon == null:
		return
	_sprite.scale = Vector2(size, size)
	_polygon.scale = Vector2(size, size)


func _set_tint(new_tint: Color):
	tint = new_tint
	if is_node_ready():
		_sprite.modulate = tint
	notify_property_list_changed()
