@tool
class_name Asteroid
extends RigidBody2D

## Use this to tint the asteroid a different color.
@export var tint: Color = Color.WHITE:
	set = _set_tint

@onready var _sprite: Sprite2D = %Sprite2D


func _set_tint(new_tint: Color):
	if not Engine.is_editor_hint():
		await ready
	if _sprite == null:
		return
	tint = new_tint
	_sprite.modulate = tint
