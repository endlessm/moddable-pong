class_name TrapSpace
extends Node2D

## How fast the walls of the trap move?
@export_range(0, 10, 0.1) var walls_speed: float = 1.0:
	set = _set_animation_speed

@onready var _animation_player: AnimationPlayer = %AnimationPlayer


func _set_animation_speed(new_speed: float):
	if not is_node_ready():
		await ready
	walls_speed = new_speed
	_animation_player.speed_scale = walls_speed
