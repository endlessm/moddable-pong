@tool
extends CharacterBody2D

## Is this the left paddle? Or the right one?
@export var player: Global.Player = Global.Player.LEFT

## This is how fast your paddle moves.
@export var speed = 1000.0

## Use this to change the texture of the paddle.
@export var texture: Texture2D = null:
	set = _set_texture

var _original_texture


func _set_texture(new_texture):
	if not Engine.is_editor_hint():
		await ready
	if _original_texture == null:
		_original_texture = texture
	texture = new_texture
	if texture != null:
		%Sprite2D.texture = texture
	else:
		%Sprite2D.texture = _original_texture


func _ready():
	if Engine.is_editor_hint():
		_set_texture(%Sprite2D.texture)


func _physics_process(_delta):
	if Engine.is_editor_hint():
		return

	var direction
	if player == Global.Player.RIGHT:
		direction = Input.get_axis("ui_up", "ui_down")
	else:
		direction = Input.get_axis("player_2_up", "player_2_down")
	if direction:
		velocity.y = direction * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()
