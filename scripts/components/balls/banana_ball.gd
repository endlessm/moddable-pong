@tool
class_name BananaBall
extends RigidBody2D

signal touched_paddle
signal touched_obstacle
signal hang

const _INITIAL_ANGULAR_VELOCITY = 10.0
const _INITIAL_RADIUS = 48
const _INITIAL_HEIGHT = 176

## This is how fast your ball moves.
@export_range(0.0, 10000.0, 0.5, "suffix:px/s") var initial_speed: float = 500.0

## This is the initial angle of the ball.
@export_range(-180, 180, 0.5, "radians_as_degrees") var initial_direction: float = PI / 4

## The ball will rotate its direction randomly. Zero is no random at all.
@export_range(0, 180, 0.5, "radians_as_degrees") var random_angle: float = PI / 4

## How big is this ball?
@export_range(0.1, 5.0, 0.1) var size: float = 1.0:
	set = _set_size

## Use this to tint the texture of the ball a different color.
@export var tint: Color = Color.WHITE:
	set = _set_tint

## How many seconds to wait until a ball is considered "hanged". The timer resets when the ball
## hits a paddle or obstacle. If the timer reaches zero, for example because the ball has become
## stuck, the ball will be respawned.
## If this is set to zero, the hang timer will not be used.
@export_range(0.0, 180.0, 0.1, "suffix:s") var hang_time: float = 20.0

var _hang_timer: SceneTreeTimer

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
	tint = new_tint
	if is_node_ready():
		_sprite.modulate = tint
	notify_property_list_changed()


func _ready():
	if Engine.is_editor_hint():
		set_process(false)
		set_physics_process(false)
	reset()
	_set_tint(tint)


func reset():
	linear_velocity = Vector2.from_angle(initial_direction) * initial_speed
	angular_velocity = _INITIAL_ANGULAR_VELOCITY
	_set_size(size)
	if hang_time != 0:
		_hang_timer = get_tree().create_timer(hang_time)
		_hang_timer.timeout.connect(_on_hang)


func _on_hang():
	hang.emit(self)


func _on_body_entered(body: Node2D):
	DampedOscillator.animate(self, "scale", 1600.0, 4.0, 15.0, 0.75)
	var angle = randf_range(-random_angle, random_angle)
	linear_velocity = linear_velocity.rotated(angle)
	if body.is_in_group("paddles"):
		body.on_ball_hit()
		$PaddleAudioStreamPlayer.play()
		touched_paddle.emit()
	else:
		$WallAudioStreamPlayer.play()
		if body.is_in_group("obstacles"):
			touched_obstacle.emit()
