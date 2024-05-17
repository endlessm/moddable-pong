extends Node

## If not zero, the ball velocity will be multiplied by this number each time it bounces on a paddle.
@export_range(0.0, 10.0, 0.1, "or_greater") var ball_velocity_multiplier: float = 0.0

var bounce_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.goal_scored.connect(_on_goal_scored)
	_spawn_balls()


func _spawn_balls():
	for spawner in get_tree().get_nodes_in_group("ball spawners"):
		var ball = spawner.spawn()
		ball.touched_paddle.connect(_on_ball_touched_paddle)


func _on_ball_touched_paddle():
	bounce_count += 1
	var hud = get_tree().get_first_node_in_group("hud")
	hud.set_players_scores(bounce_count, bounce_count)

	if ball_velocity_multiplier == 0:
		return
	for ball in get_tree().get_nodes_in_group("balls"):
		ball.linear_velocity *= ball_velocity_multiplier


func _on_goal_scored(_ball, _side):
	# TODO: Show "you lose" message instead.
	get_tree().quit()
