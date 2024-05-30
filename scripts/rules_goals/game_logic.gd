class_name GameLogic
extends Node

@export_group("Initial score")

## Starting score of the left side player
@export var left_initial_score: int = 0

## Starting score of the right side player
@export var right_initial_score: int = 0

@export_group("Scoring on Left Goal")

## Score when the goal belonging to the left player is reached?
@export var score_on_left_goal_reached: bool = true

## How much to score when the goal at the left is reached?
@export var left_goal_points: int = 1

## Which player should receive the points when the goal at the left is reached?
@export var left_goal_scoring_player: Global.Player = Global.Player.RIGHT

@export_group("Scoring on Right Goal")

## Score when the goal belonging to the right player is reached?
@export var score_on_right_goal_reached: bool = true

## How much to score when the goal at the right is reached?
@export var right_goal_points: int = 1

## Which player should receive the points when the goal at the right is reached?
@export var right_goal_scoring_player: Global.Player = Global.Player.LEFT

@export_group("Scoring on Paddle Touched")

## Score when the ball touches the paddles?
@export var score_on_paddle_touched: bool = false

## How many points for when the ball touches the paddles?
@export var paddle_touched_points: int = 1

## Which player should receive the points when the ball touches the paddles?
@export var paddle_touched_scoring_player: Global.Player = Global.Player.RIGHT

@export_group("Scoring on Obstacles Touched")

## Score when the ball touches an obstacle?
@export var score_on_obstacle_touched: bool = false

## How many points for when the ball touches an obstacle?
@export var obstacle_touched_points: int = 1

## Which player should receive the points when the ball touches an obstacle?
@export var obstacle_touched_scoring_player: Global.Player = Global.Player.RIGHT

@export_group("End Game Condition")

## End the game when a ball scores?
@export var end_on_first_goal_reached: bool = false

## End the game when a ball touches an obstacle?
@export var end_on_first_obstacle_reached: bool = false

@export_group("Ball Properties")

## The ball velocity will be multiplied by this number each time it bounces on a paddle.
@export_range(0.5, 2.0, 0.1) var ball_velocity_multiplier: float = 1.0

## The ball size will be multiplied by this number each time it bounces on a paddle.
@export_range(0.8, 1.2, 0.1) var ball_size_multiplier: float = 1.0

var _last_player_scored: Global.Player = Global.Player.LEFT


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.goal_scored.connect(_on_goal_scored)
	await Global.hud_added
	Global.add_score(Global.Player.LEFT, left_initial_score)
	Global.add_score(Global.Player.RIGHT, right_initial_score)
	_spawn_balls()


func _spawn_balls(player: Global.Player = Global.Player.LEFT):
	for spawner in get_tree().get_nodes_in_group("ball spawners"):
		_spawn_ball(spawner, player)


func _spawn_ball(spawner, player: Global.Player = Global.Player.LEFT):
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
	ball.touched_obstacle.connect(_on_ball_touched_obstacle)
	ball.hang.connect(_on_ball_hang)


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
	if score_on_paddle_touched:
		Global.add_score(paddle_touched_scoring_player, paddle_touched_points)


func _on_ball_touched_obstacle():
	if end_on_first_obstacle_reached:
		# TODO: Show "you lose" message instead.
		get_tree().quit()
	if score_on_obstacle_touched:
		Global.add_score(obstacle_touched_scoring_player, obstacle_touched_points)


func _on_ball_hang(ball):
	var spawner = ball.get_meta("spawner")
	ball.queue_free()
	if spawner != null:
		_spawn_ball(spawner, _last_player_scored)


func _on_goal_scored(ball: Node2D, player: Global.Player):
	if end_on_first_goal_reached:
		# TODO: Show "you lose" message instead.
		get_tree().quit()

	if score_on_left_goal_reached and player == Global.Player.LEFT:
		Global.add_score(left_goal_scoring_player, left_goal_points)
	elif score_on_right_goal_reached and player == Global.Player.RIGHT:
		Global.add_score(right_goal_scoring_player, right_goal_points)
	var spawner = ball.get_meta("spawner")
	ball.queue_free()
	if spawner != null:
		_spawn_ball(spawner, player)
