class_name ElasticPaddle
extends CharacterBody2D

## Is this the left paddle? Or the right one?
@export var player: Global.Player = Global.Player.LEFT

## How long can this paddle be.
@export_range(0, 1200, 2) var max_length: float = 600.0

## This is how fast your paddle enlarges.
@export_range(0, 100, 0.1) var enlarge_speed: float = 20.0

## This is how fast your paddle shrinks.
@export_range(0, 100, 0.1) var shrink_speed: float = 50.0

## This is how fast your paddle moves.
@export_range(0, 3000.0, 5.0) var speed: float = 1000.0

var _last_direction: float = 1

@onready var _shape: RectangleShape2D = %CollisionShape2D.shape

@onready var _initial_length: float = _shape.size.y

@onready var _asset: NinePatchRect = %NinePatchRect
@onready var _asset_initial_position_y: float = %NinePatchRect.position.y


func _physics_process(_delta: float):
	var direction: float
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
		_asset.position.y = move_toward(
			%NinePatchRect.position.y, _asset_initial_position_y, shrink_speed
		)

	move_and_slide()


func on_ball_hit():
	DampedOscillator.animate(%NinePatchRect, "scale", 600.0, 20.0, -15.0, 0.75)
