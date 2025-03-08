extends Control

@export var inventory_dict: Dictionary = {"KEYS":0,"MEMORY FRAGMENTS":0}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_inventory_display()
	pass # Replace with function body.

func update_inventory_display():
	#clear previous display


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
