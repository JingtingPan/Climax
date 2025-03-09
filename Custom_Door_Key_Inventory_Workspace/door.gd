extends Area2D

#default initialization:
#door is locked, player is not near
@export var locked: bool = true
var player_near: bool = false


@onready var item = $Item_Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite_Locked_Door.show()
	#$Sprite_Opened_Cavity.hide()
	$Item_Node2D.hide()
	locked = true
	player_near = false
	
func unlock():
	locked = false
	$Sprite_Locked_Door.hide()
	#$Sprite_Opened_Cavity.show()
	$Item_Node2D.show()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if player_near and Input.is_action_just_pressed("interact"):
		if locked and Inventory.inventory_dict["KEYS"] > 0:
			unlock()
			Inventory.remove_from_inventory("KEY")
	
	if $Item_Node2D.collected:
		#print("Item is collected, freeing it")
		queue_free()
	

#player enters the door
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		#print("player near door")
		player_near = true
		
#player leaves the door
func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_near = false
