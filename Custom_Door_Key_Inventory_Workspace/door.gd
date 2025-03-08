extends Node2D

@export var locked: bool = true
var player_near: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite_Locked_Door.show()
	$Sprite_Opened_Cavity.hide()
	$Item_Node2D.hide()
	
func unlock():
	locked = false
	$Sprite_Locked_Door.hide()
	$Sprite_Opened_Cavity.show()
	show_item()
	inventory_add(item_name)
	
	
func show_item():
	$Item_Node2D.show()
	await get_tree().create_timer(2).timeout
	$Item_Node2D.hide()

func inventory_add(item_name):	
	pass
	#add 1 to dictionary key matching item name
	#Note: Inventory dict should be initialized to:
	#{"key":0,"memory_fragment":0}
	
	#possible sound effect
	
func _on_DoorArea_Area2d_body_entered(body):
	#Insert if statement header such as:
	#if body.name = "Player":
	player_near = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#"interact" in line below is a placeholder
	# player could press q or something
	if player_near and Input.is_action_just_pressed(interact):
		if not locked:
			unlock()
	
