extends Node

@export_group("Initial score")

## Initial score of the left player
@export var left_initial_score: int = 0

## Initial score of the right player
@export var right_initial_score: int = 0

@export_group("Scoring On Goal Left")

## Score when the goal belonging to the left player is reached?
@export var on_goal_left_reached: bool = true

## How much to score when the goal at the left is reached?
@export var goal_left_reached_points: int = 1

## Which player should receive the points when the goal at the left is reached?
@export var goal_left_reached_player: Global.Player = Global.Player.RIGHT

@export_group("Scoring On Goal Right")

## Score when the goal belonging to the right player is reached?
@export var on_goal_right_reached: bool = true

## How much to score when the goal at the right is reached?
@export var goal_right_reached_points: int = 1

## Which player should receive the points when the goal at the right is reached?
@export var goal_right_reached_player: Global.Player = Global.Player.LEFT

@export_group("Scoring On Paddle Touched")

## Score when the ball touches the paddles?
@export var on_paddle_touched: bool = false

## How much to score when the ball touches the paddles?
@export var paddle_touched_points: int = 1

## Which player should receive the points when the ball touches the paddles?
@export var paddle_touched_player: Global.Player = Global.Player.RIGHT

@export_group("Scoring On Obstacles Touched")

## Score when the ball touches an obstacle?
@export var on_obstacle_touched: bool = false

## How much to score when the ball touches an obstacle?
@export var obstacle_touched_points: int = 1

## Which player should receive the points when the ball touches an obstacle?
@export var obstacle_touched_player: Global.Player = Global.Player.RIGHT

@export_group("End Game Condition")

## End the game when a ball scores?
@export var end_on_goal_reached: bool = false

## End the game when a ball touches an obstacle?
@export var end_on_obstacle_touched: bool = false

@export_group("Ball Properties")

## The ball velocity will be multiplied by this number each time it bounces on a paddle.
@export_range(0.5, 2.0, 0.1) var ball_velocity_multiplier: float = 1.0

## The ball size will be multiplied by this number each time it bounces on a paddle.
@export_range(0.8, 1.2, 0.1) var ball_size_multiplier: float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.goal_scored.connect(_on_goal_scored)
	await Global.hud_added
	Global.add_score(Global.Player.LEFT, left_initial_score)
	Global.add_score(Global.Player.RIGHT, right_initial_score)
	_spawn_balls()


func _spawn_balls(player: Global.Player = Global.Player.LEFT):
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
		ball.touched_obstacle.connect(_on_ball_touched_obstacle)


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
	if on_paddle_touched:
		Global.add_score(paddle_touched_player, paddle_touched_points)


func _on_ball_touched_obstacle():
	if end_on_obstacle_touched:
		# TODO: Show "you lose" message instead.
		get_tree().quit()
	if on_obstacle_touched:
		Global.add_score(obstacle_touched_player, obstacle_touched_points)


func _on_goal_scored(ball: Node2D, player: Global.Player):
	if end_on_goal_reached:
		# TODO: Show "you lose" message instead.
		get_tree().quit()

	if on_goal_left_reached and player == Global.Player.LEFT:
		Global.add_score(goal_left_reached_player, goal_left_reached_points)
	elif on_goal_right_reached and player == Global.Player.RIGHT:
		Global.add_score(goal_right_reached_player, goal_right_reached_points)
	ball.queue_free()
	_spawn_balls(player)
