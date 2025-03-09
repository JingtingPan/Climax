extends Area2D
@onready var notice = $Label

var player_near :bool = false
var door_locked :bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$doorclosed.show()
	$doorOpen.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_near and door_locked:
		if Input.is_action_just_pressed("interact"):
			if Inventory.inventory_dict["KEYS"] > 0:
				unlock()
				Inventory.remove_from_inventory("KEY")
				$doorclosed.hide()
				$doorOpen.show()
			
			else:
				notice.text = "Not enough key!"
				await get_tree().create_timer(2).timeout
				notice.text = ""
				#print("you dont have key")
	elif player_near and not door_locked:
		if Input.is_action_just_pressed("interact"):
			notice.text = "Onto the next dream!"	


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_near = true
		
func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_near = false

func unlock():
	door_locked = false
