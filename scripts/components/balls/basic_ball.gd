extends RigidBody2D

signal touched_paddle


func _on_body_entered(body):
	if body.is_in_group("paddles"):
		touched_paddle.emit()
