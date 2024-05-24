@tool
class_name BasicBall
extends RigidBody2D

signal touched_paddle
signal touched_obstacle

const _INITIAL_RADIUS: int = 64

## This is how fast your ball moves.
@export_range(0.0, 10000.0, 1.0, "suffix:px/s") var initial_speed: float = 500.0

## This is the initial angle of the ball.
@export_range(-180, 180, 1.0, "radians_as_degrees") var initial_direction: float = PI / 4

## How big is this ball?
@export_range(0.1, 5.0, 0.1) var size: float = 1.0:
	set = _set_size

## Use this to change the texture of the ball.
@export var texture: Texture2D = null:
	set = _set_texture

## Use this to tint the texture of the ball a different color.
@export var tint: Color = Color.WHITE:
	set = _set_tint

var _initial_texture: Texture2D

@onready var _shape: CollisionShape2D = %CollisionShape2D
@onready var _sprite: Sprite2D = %Sprite2D


func _set_size(new_size: float):
	size = new_size
	if _shape == null or _sprite == null:
		return
	_shape.shape.radius = _INITIAL_RADIUS * size
	_sprite.scale = Vector2(size, size)


func _set_texture(new_texture: Texture2D):
	if not Engine.is_editor_hint():
		await ready
	if _initial_texture == null:
		_initial_texture = texture
	texture = new_texture
	if _sprite == null:
		return
	if texture != null:
		_sprite.texture = texture
	else:
		_sprite.texture = _initial_texture


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
	if Engine.is_editor_hint():
		_set_texture(_sprite.texture)


func reset():
	linear_velocity = Vector2.from_angle(initial_direction) * initial_speed
	angular_velocity = 0.0
	_set_size(size)


func _on_body_entered(body: Node2D):
	if body.is_in_group("paddles"):
		$PaddleAudioStreamPlayer.play()
		touched_paddle.emit()
	else:
		$WallAudioStreamPlayer.play()
		if body.is_in_group("obstacles"):
			touched_obstacle.emit()
