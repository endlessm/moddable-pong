extends Node

signal hud_added
signal score_changed
signal goal_scored(ball: Node2D, player: Player)

enum Player { LEFT, RIGHT, BOTH }

## Stores the score for each player.
var score = {
	Player.LEFT: 0,
	Player.RIGHT: 0,
}


func score_goal(ball: Node2D, player: Player):
	goal_scored.emit(ball, player)


func add_score(player: Player, value: int):
	if player == Player.BOTH:
		score[Player.RIGHT] += value
		score[Player.LEFT] += value
	else:
		score[player] += value
	score_changed.emit()
