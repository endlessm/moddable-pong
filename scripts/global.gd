extends Node

enum Player {LEFT, RIGHT, BOTH}

## Stores the score for each player.
var score = {
	Player.LEFT: 0,
	Player.RIGHT: 0,
}

signal hud_added
signal score_changed()
signal goal_scored(ball, player)

func score_goal(ball: RigidBody2D, player: Player):
	goal_scored.emit(ball, player)


func add_score(player: Player, value: int):
	if player == Player.BOTH:
		score[Player.RIGHT] += value
		score[Player.LEFT] += value
	else:
		score[player] += value
	score_changed.emit()
