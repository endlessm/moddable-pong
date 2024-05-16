extends CharacterBody2D

## Is this the left paddle? Or the right one?
@export var side: Global.Direction = Global.Direction.LEFT

## This is how fast your paddle moves.
@export var speed = 1000.0


func _physics_process(_delta):
	var direction: Vector2
	if side == Global.Direction.RIGHT:
		direction.x = Input.get_axis("ui_up", "ui_down")
		direction.y = Input.get_axis("ui_left", "ui_right")
	else:
		direction.x = Input.get_axis("player_2_left", "player_2_right")
		direction.y = Input.get_axis("player_2_up", "player_2_down")
	if direction != Vector2.ZERO:
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()
