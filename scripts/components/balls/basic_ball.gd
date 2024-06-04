@tool
class_name BasicBall
extends RigidBody2D

signal touched_paddle
signal touched_obstacle
signal hang

const _INITIAL_RADIUS: int = 64

## This is how fast your ball moves.
@export_range(0.0, 10000.0, 0.5, "suffix:px/s") var initial_speed: float = 500.0

## This is the initial angle of the ball.
@export_range(-180, 180, 0.5, "radians_as_degrees") var initial_direction: float = PI / 4

## How big is this ball?
@export_range(0.1, 5.0, 0.1) var size: float = 1.0:
	set = _set_size

## Use this to change the texture of the ball.
@export var texture: Texture2D = _initial_texture:
	set = _set_texture

## Use this to tint the texture of the ball a different color.
@export var tint: Color = Color.WHITE:
	set = _set_tint

## How many seconds to wait until a ball is considered "hanged". The timer resets when the ball
## hits a paddle or obstacle. If the timer reaches zero, for example because the ball has become
## stuck, the ball will be respawned.
## If this is set to zero, the hang timer will not be used.
@export_range(0.0, 180.0, 0.1, "suffix:s") var hang_time: float = 20.0

var _hang_timer: SceneTreeTimer

@onready var _shape: CollisionShape2D = %CollisionShape2D
@onready var _sprite: Sprite2D = %Sprite2D
@onready var _initial_texture: Texture2D = %Sprite2D.texture


func _set_size(new_size: float):
	size = new_size
	if not is_node_ready():
		await ready
	_shape.shape.radius = _INITIAL_RADIUS * size
	_sprite.scale = Vector2(size, size)


func _set_texture(new_texture: Texture2D):
	if not is_node_ready():
		await ready
	texture = new_texture
	if texture != null:
		_sprite.texture = texture
	else:
		_sprite.texture = _initial_texture
	notify_property_list_changed()


func _set_tint(new_tint: Color):
	tint = new_tint
	if is_node_ready():
		_sprite.modulate = tint
	notify_property_list_changed()


func _ready():
	if Engine.is_editor_hint():
		set_process(false)
		set_physics_process(false)
	reset()


func reset():
	linear_velocity = Vector2.from_angle(initial_direction) * initial_speed
	angular_velocity = 0.0
	_set_size(size)
	_set_texture(texture)
	_set_tint(tint)
	if hang_time != 0:
		_hang_timer = get_tree().create_timer(hang_time)
		_hang_timer.timeout.connect(_on_hang)


func _on_hang():
	hang.emit(self)


func _on_body_entered(body: Node2D):
	DampedOscillator.animate(self, "scale", 1600.0, 4.0, 5.0, 0.75)
	if body.is_in_group("paddles"):
		body.on_ball_hit()
		$PaddleAudioStreamPlayer.play()
		touched_paddle.emit()
		_hang_timer.time_left = hang_time
	else:
		$WallAudioStreamPlayer.play()
		if body.is_in_group("obstacles"):
			touched_obstacle.emit()
			_hang_timer.time_left = hang_time
