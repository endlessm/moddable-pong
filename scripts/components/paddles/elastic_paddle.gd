extends CharacterBody2D

## Is this the left paddle? Or the right one?
@export var player: Global.Player = Global.Player.LEFT

## How long can this paddle be.
@export var max_length = 600.0

## This is how fast your paddle enlarges.
@export var enlarge_speed = 20.0

## This is how fast your paddle shrinks.
@export var shrink_speed = 50.0

## This is how fast your paddle moves.
@export var speed = 1000.0

@onready var _shape: RectangleShape2D = %CollisionShape2D.shape

@onready var _initial_length = _shape.size.y

@onready var _asset = %NinePatchRect
@onready var _asset_initial_position_y = %NinePatchRect.position.y

var _last_direction = 1


func _physics_process(_delta):
	var direction
	if player == Global.Player.RIGHT:
		direction = Input.get_axis("ui_up", "ui_down")
	else:
		direction = Input.get_axis("player_2_up", "player_2_down")
	if direction:
		if _shape.size.y < max_length:
			_shape.size.y += enlarge_speed
			_asset.size.y += enlarge_speed
			_asset.position.y -= enlarge_speed / 2
			velocity.y = direction * (speed - enlarge_speed)
		else:
			velocity.y = direction * speed
		_last_direction = direction
	else:
		if _shape.size.y > _initial_length:
			velocity.y = _last_direction * (speed - shrink_speed)
		else:
			velocity.y = move_toward(velocity.y, 0, speed)
		_shape.size.y = move_toward(_shape.size.y, _initial_length, shrink_speed)
		_asset.size.y = move_toward(%NinePatchRect.size.y, _initial_length, shrink_speed)
		_asset.position.y = move_toward(%NinePatchRect.position.y, _asset_initial_position_y, shrink_speed)

	move_and_slide()
