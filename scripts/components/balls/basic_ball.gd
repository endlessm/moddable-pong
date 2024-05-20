@tool
extends RigidBody2D

## This is how fast your paddle moves.
@export_range(0.0, 10000.0, 1.0, "suffix:px/s") var initial_speed : float = 500.0

## This is the initial angle of the ball.
@export_range(-180, 180, 1.0, "radians_as_degrees") var initial_direction : float = PI/4

## Use this to change the texture of the ball.
@export var texture: Texture2D = null:
	set = _set_texture

var _original_texture
@onready var _sprite = %Sprite2D
signal touched_paddle


func _set_texture(new_texture):
	if not Engine.is_editor_hint():
		await ready
	if _original_texture == null:
		_original_texture = texture
	texture = new_texture
	if _sprite == null:
		return
	if texture != null:
		_sprite.texture = texture
	else:
		_sprite.texture = _original_texture


func _ready():
	reset()
	if Engine.is_editor_hint():
		_set_texture(_sprite.texture)


func reset():
	linear_velocity = Vector2.from_angle(initial_direction) * initial_speed
	angular_velocity = 0.0


func _on_body_entered(body):
	if body.is_in_group("paddles"):
		touched_paddle.emit()
