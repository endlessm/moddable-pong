class_name TrapSpace
extends Node2D

## How fast the walls of the trap move?
@export_range(0, 10, 0.1) var walls_speed: float = 1.0:
	set = _set_animation_speed

@onready var _animation_player: AnimationPlayer = %AnimationPlayer


func _set_animation_speed(new_speed: float):
	if not Engine.is_editor_hint():
		await ready
	if _animation_player == null:
		return
	walls_speed = new_speed
	_animation_player.speed_scale = walls_speed
