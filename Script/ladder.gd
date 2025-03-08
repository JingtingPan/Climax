extends Area2D

@onready var ladder_collision = $CollisionShape2D  # 梯子碰撞形状

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		print("enter_ladder")
		body.is_climbing = true


func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		print("exit_ladder")
		body.is_climbing = false
