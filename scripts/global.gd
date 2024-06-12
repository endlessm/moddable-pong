extends Node

signal hud_added
signal score_changed
signal goal_scored(ball: Node2D, player: Player)

enum Player { LEFT = SIDE_LEFT, RIGHT = SIDE_RIGHT, BOTH }

## Stores the score for each player.
@export var score = {
	Player.LEFT: 0,
	Player.RIGHT: 0,
}

var hud: Node = null


func set_hud(new_hud: Node):
	hud = new_hud
	hud_added.emit()


func score_goal(ball: Node2D, player: Player):
	goal_scored.emit(ball, player)


func add_score(player: Player, value: int):
	if player == Player.BOTH:
		score[Player.RIGHT] += value
		score[Player.LEFT] += value
	else:
		score[player] += value
	score_changed.emit()
	if hud:
		hud.emit_signal("score_changed", score[Player.LEFT], score[Player.RIGHT])
