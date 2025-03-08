extends Area2D
@export var animator: AnimatedSprite2D

@export var message : Array[String] = ["Hi", "Welcome"]
@onready var npc_dialog : Label = $Label  
var dialogue_index : int = 0
var can_interact: bool = false;
		
func _process(delta: float) -> void:
	
	animator.play("idle")
	if can_interact and Input.is_action_just_pressed("interact"): 
		#print("e pressed")
		if dialogue_index < message.size():
			#print(message[dialogue_index])
			npc_dialog.text = message[dialogue_index]
			dialogue_index += 1
			animator.play("talk")
		else:
			npc_dialog.text = ""  # 清除对话文本
			dialogue_index = 0  # 重置对话
			can_interact = false  # 禁止继续交互
			animator.stop()  # 恢复正常动画
	else:
		# 只有在对话尚未进行时才清空对话
		if dialogue_index == 0:
			npc_dialog.text = ""  # 清空消息
			animator.stop()
	
# 当玩家进入区域时
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		#print("player enter")
		can_interact = true
		

# 当玩家离开区域时
func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		npc_dialog.text = ""  # 清除消息
		can_interact = false
		animator.stop()
	
