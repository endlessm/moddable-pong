@tool
class_name BasicSpace
extends Node2D

const _BACKGROUND_TILE_SIZE: int = 64

## Use this to change the background texture.
@export var background_texture: Texture2D = null:
	set = _set_background_texture

## Should the background repeat? If so please provide a texture that has 3x3 tiles of 64 pixels
## size.
@export var background_repeatable: bool = true:
	set = _set_background_repeatable

var _initial_background_texture: Texture2D
@onready var _sprite: NinePatchRect = %NinePatchRect


func _set_background_texture(new_texture: Texture2D):
	if not is_node_ready():
		await ready
	if _initial_background_texture == null:
		_initial_background_texture = background_texture
	background_texture = new_texture
	if background_texture != null:
		_sprite.texture = background_texture
	else:
		_sprite.texture = _initial_background_texture


func _set_background_repeatable(new_value):
	var previous_value = background_repeatable
	background_repeatable = new_value
	if previous_value != new_value:
		if background_repeatable == true:
			_sprite.axis_stretch_horizontal = NinePatchRect.AXIS_STRETCH_MODE_TILE_FIT
			_sprite.axis_stretch_vertical = NinePatchRect.AXIS_STRETCH_MODE_TILE_FIT
			_sprite.patch_margin_top = _BACKGROUND_TILE_SIZE
			_sprite.patch_margin_bottom = _BACKGROUND_TILE_SIZE
			_sprite.patch_margin_left = _BACKGROUND_TILE_SIZE
			_sprite.patch_margin_right = _BACKGROUND_TILE_SIZE
		else:
			_sprite.axis_stretch_horizontal = NinePatchRect.AXIS_STRETCH_MODE_STRETCH
			_sprite.axis_stretch_vertical = NinePatchRect.AXIS_STRETCH_MODE_STRETCH
			_sprite.patch_margin_top = 0
			_sprite.patch_margin_bottom = 0
			_sprite.patch_margin_left = 0
			_sprite.patch_margin_right = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		set_process(false)
		set_physics_process(false)
	_set_background_texture(_sprite.texture)
