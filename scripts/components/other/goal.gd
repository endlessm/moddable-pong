class_name Goal
extends Area2D

## Which player corresponds to this goal?
@export var player: Global.Player = Global.Player.LEFT


func _on_body_entered(body: Node2D):
	if body.is_in_group("balls"):
		$AudioStreamPlayer.play()
		Global.score_goal(body, player)
