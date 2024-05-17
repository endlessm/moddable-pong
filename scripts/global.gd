extends Node

enum Player {LEFT, RIGHT}

## Counts the goals in each direction.
var goals_count = {
	Player.LEFT: 0,
	Player.RIGHT: 0,
}

signal goals_count_changed()
signal goal_scored(ball, player)

func score_goal(ball: RigidBody2D, player: Player):
	goal_scored.emit(ball, player)


func set_goals_count(player: Player, value: int):
	var previous_value = goals_count[player]
	goals_count[player] = value
	if previous_value != value:
		goals_count_changed.emit()
