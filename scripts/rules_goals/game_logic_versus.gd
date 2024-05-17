extends Node

## If not zero, the ball velocity will be multiplied by this number each time it bounces on a paddle.
@export_range(0.0, 10.0, 0.1, "or_greater") var ball_velocity_multiplier: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.goal_scored.connect(_on_goal_scored)
	Global.goals_count_changed.connect(_on_goals_count_changed)


func _spawn_balls(direction = Global.Direction.LEFT):
	for spawner in get_tree().get_nodes_in_group("ball spawners"):
		var ball = spawner.spawn(direction)
		ball.touched_paddle.connect(_on_ball_touched_paddle)


func _on_ball_touched_paddle():
	if ball_velocity_multiplier == 0:
		return
	for ball in get_tree().get_nodes_in_group("balls"):
		ball.linear_velocity *= ball_velocity_multiplier


func _on_goals_count_changed():
	var hud = get_tree().get_first_node_in_group("hud")
	hud.set_players_scores(Global.goals_count[Global.Direction.RIGHT], Global.goals_count[Global.Direction.LEFT])


func _on_goal_scored(_ball, side):
	Global.set_goals_count(side, Global.goals_count[side] + 1)
	_spawn_balls(side)
