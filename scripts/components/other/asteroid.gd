@tool
class_name Asteroid
extends RigidBody2D

## Use this to tint the asteroid a different color.
@export var tint: Color = Color.WHITE:
	set = _set_tint

@onready var _sprite: Sprite2D = %Sprite2D


func _ready():
	_set_tint(tint)


func _set_tint(new_tint: Color):
	tint = new_tint
	if is_node_ready():
		_sprite.modulate = tint
	notify_property_list_changed()
