extends Area2D
@onready var ladder_collision = $CollisionShape2D  # 梯子碰撞形状

func _ready():
	add_to_group("ladder")
	#print("Ladder added to group: ", self.name)
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		#print("enter_ladder")
		body.is_climbing = true
	

func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.is_climbing = false
