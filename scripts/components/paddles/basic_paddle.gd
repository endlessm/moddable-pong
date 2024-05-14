extends CharacterBody2D

enum Direction {LEFT, RIGHT}
@export var side: Direction = Direction.LEFT

@export var speed = 1000.0


func _physics_process(delta):
	var direction
	if side == Direction.RIGHT:
		direction = Input.get_axis("ui_up", "ui_down")
	else:
		direction = Input.get_axis("player_2_up", "player_2_down")
	if direction:
		velocity.y = direction * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()
