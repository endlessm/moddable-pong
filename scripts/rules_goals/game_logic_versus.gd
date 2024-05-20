extends Node

## The ball velocity will be multiplied by this number each time it bounces on a paddle.
@export_range(0.5, 2.0, 0.1) var ball_velocity_multiplier: float = 1.0

## The ball size will be multiplied by this number each time it bounces on a paddle.
@export_range(0.8, 1.2, 0.1) var ball_size_multiplier: float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.goal_scored.connect(_on_goal_scored)
	Global.goals_count_changed.connect(_on_goals_count_changed)
	_spawn_balls()


func _spawn_balls(player = Global.Player.LEFT):
	for spawner in get_tree().get_nodes_in_group("ball spawners"):
		var ball = spawner.spawn()

		# Force the ball to move in the direction corresponding to the provided
		# player. Use Vector2.from_angle to convert ball.initial_direction to a
		# vector, which is convenient for determining its horizontal direction.
		var ball_vector = Vector2.from_angle(ball.initial_direction)
		if player == Global.Player.LEFT and ball_vector.x < 0:
			ball.initial_direction = ball_vector.reflect(Vector2.UP).angle()
		elif player == Global.Player.RIGHT and ball_vector.x > 0:
			ball.initial_direction = ball_vector.reflect(Vector2.UP).angle()

		ball.touched_paddle.connect(_on_ball_touched_paddle)


func _update_balls_velocity():
	if ball_velocity_multiplier == 1:
		return
	for ball in get_tree().get_nodes_in_group("balls"):
		ball.linear_velocity *= ball_velocity_multiplier


func _update_balls_size():
	if ball_size_multiplier == 1:
		return
	for ball in get_tree().get_nodes_in_group("balls"):
		ball.size *= ball_size_multiplier


func _on_ball_touched_paddle():
	_update_balls_velocity()
	_update_balls_size()


func _on_goals_count_changed():
	var hud = get_tree().get_first_node_in_group("hud")
	hud.set_players_scores(Global.goals_count[Global.Player.RIGHT], Global.goals_count[Global.Player.LEFT])


func _on_goal_scored(ball, player):
	Global.set_goals_count(player, Global.goals_count[player] + 1)
	ball.queue_free()
	_spawn_balls(player)
