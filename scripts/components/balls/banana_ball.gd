@tool
class_name BananaBall
extends RigidBody2D

signal touched_paddle
signal touched_obstacle

const _INITIAL_ANGULAR_VELOCITY = 10.0
const _INITIAL_RADIUS = 48
const _INITIAL_HEIGHT = 176

## This is how fast your ball moves.
@export_range(0.0, 10000.0, 1.0, "suffix:px/s") var initial_speed: float = 500.0

## This is the initial angle of the ball.
@export_range(-180, 180, 1.0, "radians_as_degrees") var initial_direction: float = PI / 4

## The ball will rotate its direction randomly. Zero is no random at all.
@export_range(0, 180, 1, "radians_as_degrees") var random_angle: float = PI / 4

## How big is this ball?
@export_range(0.1, 5.0, 0.1) var size: float = 1.0:
	set = _set_size

## Use this to tint the texture of the ball a different color.
@export var tint: Color = Color.WHITE:
	set = _set_tint

@onready var _shape: CapsuleShape2D = %CollisionShape2D.shape
@onready var _sprite = %Sprite2D


func _set_size(new_size: float):
	size = new_size
	if _shape == null or _sprite == null:
		return
	_shape.radius = _INITIAL_RADIUS * size
	_shape.height = _INITIAL_HEIGHT * size
	_sprite.scale = Vector2(size, size)


func _set_tint(new_tint: Color):
	if not Engine.is_editor_hint():
		await ready
	if _sprite == null:
		return
	tint = new_tint
	_sprite.modulate = tint


func _ready():
	if Engine.is_editor_hint():
		set_process(false)
		set_physics_process(false)
	reset()


func reset():
	linear_velocity = Vector2.from_angle(initial_direction) * initial_speed
	angular_velocity = _INITIAL_ANGULAR_VELOCITY
	_set_size(size)


func _on_body_entered(body: Node2D):
	var angle = randf_range(-random_angle, random_angle)
	linear_velocity = linear_velocity.rotated(angle)
	if body.is_in_group("paddles"):
		$PaddleAudioStreamPlayer.play()
		touched_paddle.emit()
	else:
		$WallAudioStreamPlayer.play()
		if body.is_in_group("obstacles"):
			touched_obstacle.emit()
