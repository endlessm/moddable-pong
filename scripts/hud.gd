extends CanvasLayer

@onready var _score_labels = {
	Global.Player.LEFT: %PlayerLeftScore,
	Global.Player.RIGHT: %PlayerRightScore,
}


## Sets the score for each player:
func set_players_scores(left_score, right_score):
	_score_labels[Global.Player.LEFT].text = str(left_score)
	_score_labels[Global.Player.RIGHT].text = str(right_score)
