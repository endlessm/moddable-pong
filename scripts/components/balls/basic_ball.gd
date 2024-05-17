extends RigidBody2D

## This is how fast your paddle moves.
@export_range(0.0, 10000.0, 1.0, "suffix:px/s") var initial_speed : float = 500.0

## This is the initial angle of the ball.
@export_range(-180, 180, 1.0, "radians_as_degrees") var initial_direction : float = PI/4

signal touched_paddle


func _ready():
	reset()


func reset():
	linear_velocity = Vector2.from_angle(initial_direction) * initial_speed
	angular_velocity = 0.0


func _on_body_entered(body):
	if body.is_in_group("paddles"):
		touched_paddle.emit()
