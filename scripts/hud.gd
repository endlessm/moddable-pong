@tool
extends CanvasLayer

## The color of the scores and middle line.
@export var color: Color = Color.WHITE:
	set = _set_color

@onready var _score_labels = {
	Global.Player.LEFT: %PlayerLeftScore,
	Global.Player.RIGHT: %PlayerRightScore,
}


func _set_color(new_color):
	if not Engine.is_editor_hint():
		await ready
	color = new_color
	%Lines.modulate = color
	for label in _score_labels.values():
		label.add_theme_color_override("font_color", color)


## Sets the score for each player:
func set_players_scores(left_score, right_score):
	_score_labels[Global.Player.LEFT].text = str(left_score)
	_score_labels[Global.Player.RIGHT].text = str(right_score)
