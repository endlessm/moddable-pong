class_name Goal
extends Area2D

## The side of which player corresponds to this goal?
@export var side: Global.Direction = Global.Direction.LEFT


func _on_body_entered(body):
	if body.is_in_group("balls"):
		Global.score_goal(body, side)
