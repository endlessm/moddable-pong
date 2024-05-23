@tool
extends CharacterBody2D

## Is this the left paddle? Or the right one?
@export var player: Global.Player = Global.Player.LEFT:
	set = _set_player

## This is how fast your paddle moves.
@export var speed: float = 1000.0


func _set_player(new_player: Global.Player):
	if not Engine.is_editor_hint():
		await ready
	player = new_player
	%Sprite2D.flip_h = player == Global.Player.RIGHT


func _physics_process(_delta: float):
	if Engine.is_editor_hint():
		return
	var direction: Vector2
	if player == Global.Player.RIGHT:
		direction.x = Input.get_axis("ui_left", "ui_right")
		direction.y = Input.get_axis("ui_up", "ui_down")
	else:
		direction.x = Input.get_axis("player_2_left", "player_2_right")
		direction.y = Input.get_axis("player_2_up", "player_2_down")
	if direction != Vector2.ZERO:
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()
