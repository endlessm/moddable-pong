extends RigidBody2D

## The ball will rotate its direction randomly. Zero is no random at all.
@export_range(0, 180, 1, "radians_as_degrees") var random_angle: float = 0.5

signal touched_paddle


func _on_body_entered(body):
	var angle = randf_range(-random_angle, random_angle)
	linear_velocity = linear_velocity.rotated(angle)
	if body.is_in_group("paddles"):
		touched_paddle.emit()
