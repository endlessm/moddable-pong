class_name Goal
extends Area2D

## The side of which player corresponds to this goal?
@export var side: Global.Direction = Global.Direction.LEFT

signal goal_scored


# Called when the node enters the scene tree for the first time.
func _ready():
	goal_scored.connect(_on_goal_scored)


func _on_goal_scored(_side):
	Global.set_goals_count(side, Global.goals_count[side] + 1)


func _on_body_entered(body):
	if body.is_in_group("balls"):
		goal_scored.emit(side)
		body.queue_free()
