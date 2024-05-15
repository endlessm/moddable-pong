extends CanvasLayer

@onready var _score_labels = {
	Global.Direction.LEFT: %PlayerLeftScore,
	Global.Direction.RIGHT: %PlayerRightScore,
}


## Sets the score for each player:
func set_players_scores(left_score, right_score):
	prints(left_score, right_score)
	_score_labels[Global.Direction.LEFT].text = str(left_score)
	_score_labels[Global.Direction.RIGHT].text = str(right_score)
