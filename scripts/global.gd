extends Node

enum Direction {LEFT, RIGHT}

## Counts the goals in each direction.
var goals_count = {
	Direction.LEFT: 0,
	Direction.RIGHT: 0,
}

signal goals_count_changed

func set_goals_count(direction: Direction, value: int):
	var previous_value = goals_count[direction]
	goals_count[direction] = value
	if previous_value != value:
		goals_count_changed.emit()
