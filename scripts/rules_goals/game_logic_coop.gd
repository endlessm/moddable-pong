extends Node

## The ball velocity will be multiplied by this number each time it bounces on a paddle.
@export_range(0.5, 2.0, 0.1) var ball_velocity_multiplier: float = 1.0

## The ball size will be multiplied by this number each time it bounces on a paddle.
@export_range(0.8, 1.2, 0.1) var ball_size_multiplier: float = 1.0

var _bounce_count = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.goal_scored.connect(_on_goal_scored)
	_spawn_balls()


func _spawn_balls():
	for spawner in get_tree().get_nodes_in_group("ball spawners"):
		var ball = spawner.spawn()
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
	_bounce_count += 1
	var hud = get_tree().get_first_node_in_group("hud")
	hud.set_players_scores(_bounce_count, _bounce_count)

	_update_balls_velocity()
	_update_balls_size()


func _on_goal_scored(_ball, _side):
	# TODO: Show "you lose" message instead.
	get_tree().quit()
