extends Control

@export var inventory_dict = {"KEYS":0,"MEMORY FRAGMENTS":0}
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	update_inventory_display()


func update_inventory_display():
	#clear previous display
	for child in get_children():
		child.queue_free()
	#loop through inventory_dict to update item count
	for item_name in inventory_dict.keys():
		var display_item = HBoxContainer.new()
		var item_label = Label.new()
		item_label.text = item_name + ": " + str(inventory_dict[item_name])
		display_item.add_child(item_label)
		
		add_child(display_item)

func add_to_inventory(item_name: String):
	if (item_name.to_upper() == "KEY"):
		inventory_dict["KEYS"]+=1
	elif (item_name.to_upper().contains("MEMORY")):
		inventory_dict["MEMORY FRAGMENTS"]+=1
	
	update_inventory_display()
	
func remove_from_inventory(item_name: String):
	if (item_name.to_upper() == "KEY") and inventory_dict["KEYS"] >= 0:
		inventory_dict["KEYS"]-=1
	elif (item_name.to_upper().contains("MEMORY"))and inventory_dict["MEMORY FRAGMENTS"] >= 0:
		inventory_dict["MEMORY FRAGMENTS"]-=1
	
	update_inventory_display()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
