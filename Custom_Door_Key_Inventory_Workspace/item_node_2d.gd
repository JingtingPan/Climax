extends Node2D


@export var item_name: String
@export var sprite_texture: Texture
@export var collected: bool
var InventoryDisplayScript = preload("res://Custom_Door_Key_Inventory_Workspace/inventory_display_control.gd")
@onready var inventory_display = $Inventory_Display_Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite = $Sprite_Item
	collected = false


func collect() -> void:
	if not collected:
		inventory_display.add_to_inventory(item_name)
		collected = true
		self.hide()
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
