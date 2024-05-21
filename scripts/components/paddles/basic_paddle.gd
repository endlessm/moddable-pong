@tool
extends CharacterBody2D

## Is this the left paddle? Or the right one?
@export var player: Global.Player = Global.Player.LEFT

## This is how fast your paddle moves.
@export var speed = 1000.0

## Should the paddle be able to move left and right?
@export var tennis_movement: bool = false

## Use this to change the texture of the paddle.
@export var texture: Texture2D = null:
	set = _set_texture

var _original_texture
@onready var _sprite = %Sprite2D

func _set_texture(new_texture):
	if not Engine.is_editor_hint():
		await ready
	if _original_texture == null:
		_original_texture = texture
	texture = new_texture
	if _sprite == null:
		return
	if texture != null:
		_sprite.texture = texture
	else:
		_sprite.texture = _original_texture


func _ready():
	if Engine.is_editor_hint():
		_set_texture(_sprite.texture)


func _physics_process(_delta):
	if Engine.is_editor_hint():
		return

	var direction
	if player == Global.Player.RIGHT:
		direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	else:
		direction = Input.get_vector("player_2_left", "player_2_right", "player_2_up", "player_2_down")
	if direction:
		if not tennis_movement:
			direction.x = 0
			direction = direction.normalized() # Ensure up and down movement isn't affected by left-right input (see Input.get_vector length limiting)
		velocity = direction * speed
	else:
		velocity = Vector2(0,0)

	move_and_slide()
