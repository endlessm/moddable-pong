extends Node

## If not zero, the ball velocity will be multiplied by this number each time it bounces on a paddle.
@export_range(0.0, 10.0, 0.1, "or_greater") var ball_velocity_multiplier: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.goal_scored.connect(_on_goal_scored)
	Global.goals_count_changed.connect(_on_goals_count_changed)


func _spawn_balls(side = Global.Direction.LEFT):
	for spawner in get_tree().get_nodes_in_group("ball spawners"):
		var ball = spawner.spawn()

		# Force the ball to move in the direction corresponding to the provided
		# side. Use Vector2.from_angle to convert ball.initial_direction to a
		# vector, which is convenient for determining its horizontal direction.
		var ball_vector = Vector2.from_angle(ball.initial_direction)
		if side == Global.Direction.LEFT and ball_vector.x < 0:
			ball.initial_direction = ball_vector.reflect(Vector2.UP).angle()
		elif side == Global.Direction.RIGHT and ball_vector.x > 0:
			ball.initial_direction = ball_vector.reflect(Vector2.UP).angle()

		ball.touched_paddle.connect(_on_ball_touched_paddle)


func _on_ball_touched_paddle():
	if ball_velocity_multiplier == 0:
		return
	for ball in get_tree().get_nodes_in_group("balls"):
		ball.linear_velocity *= ball_velocity_multiplier


func _on_goals_count_changed():
	var hud = get_tree().get_first_node_in_group("hud")
	hud.set_players_scores(Global.goals_count[Global.Direction.RIGHT], Global.goals_count[Global.Direction.LEFT])


func _on_goal_scored(ball, side):
	Global.set_goals_count(side, Global.goals_count[side] + 1)
	ball.queue_free()
	_spawn_balls(side)
