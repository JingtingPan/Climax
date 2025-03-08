extends Node2D

#default initialization:
#door is locked, player is not near
@export var locked: bool = true
var player_near: bool = false

var InventoryDisplayScript = preload("res://Custom_Door_Key_Inventory_Workspace/inventory_display_control.gd")
@onready var inventory_display = $Inventory_Display_Control

var ItemNodeScript = preload("res://Custom_Door_Key_Inventory_Workspace/item_node_2d.gd")
@onready var item = $Door/Item_Node2D


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
	item.collect()
	

func show_item():
	$Item_Node2D.show()
	await get_tree().create_timer(2).timeout
	
	
func _on_DoorArea_Area2d_body_entered(body):
	#Insert if statement header such as:
	#if body.name = player_name
	player_near = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#"interact" in line below is a placeholder
	# player could press q or something
	if player_near and Input.is_action_just_pressed("KEY_Q"):
		if not locked:
			unlock()
	
