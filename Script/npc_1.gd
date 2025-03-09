extends Area2D
@export var animator: AnimatedSprite2D
@export var messageLow : Array[String] = ["Hello, traveler. You seem lost", "This dreamscape should be peaceful... \nCan you feel the tranquility of this land?", "Hmm, but something’s off. \nI can sense the dream slipping into chaos...", "There is a core, hidden somewhere in this dream. \nIf you can find it, it might just be able to restore balance.", "There seems to be a lot of doors...","Which door calls to you?","The return to your childhood? \nAn escape from the world? \nOr perhaps a magic box?"]
#@export var messageLow : Array[String] = ["Ah! Another pilgrim chasing the dream! \nTell me -- do you want to go to heaven or hell?", "Lost? Splendid!" ,"Which door calls to you?","The return to your childhood?", "An escape from the world?"," Or perhaps a magic box?"]
@export var messageMid : Array[String] = ["Oh, you finally found your way here... \nI thought you’d never arrive.", "The dream is starting to... shift. \nCan’t you feel it? Entropy is spreading...", "Finding the core is your only choice... \nif you even remember what that is." , "How do you define right and wrong?"]
@export var messageHigh : Array[String] = ["The dream’s no longer under your control... \nIt’s mine now.","Psst—the door's a lie. But the second door? \nAlso a lie! Magnificent, isn't it?", "Thought that was the exit? Wrong! \nClimbing so high will lead you into the heavens", "Still chasing after an exit? \nHere’s the truth—there is none. \nThere’s only... me." , "NO ,NO , NO, Regrets cannot be made up."]
@onready var npc_dialog : Label = $Label  
var dialogue_index : int = 0
var can_interact: bool = false;
var state : int = 0 #0 for low entro, 1 for mid, 2 for high

func _ready():
	# 监听 Inventory 单例的信号
	Inventory.status_changed.connect(update_status)
	update_status(Inventory.entropyLevel)  # 初始化 UI
	

func _process(delta: float) -> void:
	
	animator.play("idle")
	if can_interact and Input.is_action_just_pressed("interact"): 
		play_dialogue()
	else:
		# 只有在对话尚未进行时才清空对话
		if dialogue_index == 0:
			npc_dialog.text = ""  # 清空消息
			animator.stop()

func play_dialogue():
	#print("e pressed")
	if state == 0:
		if dialogue_index < messageLow.size():
			#print(message[dialogue_index])
			npc_dialog.text = messageLow[dialogue_index]
			dialogue_index += 1
			animator.play("talk")
		else:
			npc_dialog.text = ""  # 清除对话文本
			dialogue_index = 0  # 重置对话
			animator.stop()  # 恢复正常动画
	elif state == 1:
		if dialogue_index < messageMid.size():
			#print(message[dialogue_index])
			npc_dialog.text = messageMid[dialogue_index]
			dialogue_index += 1
			animator.play("talk")
		else:
			npc_dialog.text = ""  # 清除对话文本
			dialogue_index = 0  # 重置对话
			animator.stop()  # 恢复正常动画
	else:
		if dialogue_index < messageHigh.size():
			#print(message[dialogue_index])
			npc_dialog.text = messageHigh[dialogue_index]
			dialogue_index += 1
			animator.play("talk")
		else:
			npc_dialog.text = ""  # 清除对话文本
			dialogue_index = 0  # 重置对话
			animator.stop()  # 恢复正常动画
			
func update_status(value: int):
	if value <= 5:  # 当数值低时
		state = 0
	elif value > 5 and value <= 8:
		state = 1
	elif value > 8:
		state = 2
	
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
	
