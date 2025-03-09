extends Node2D

signal inventory_updated  # **用于通知 UI 更新**
var inventory_dict = {"KEYS": 1, "MEMORY FRAGMENTS": 0}

func add_to_inventory(item_name: String):
	if item_name.to_upper() == "KEY":
		inventory_dict["KEYS"] += 1
	elif item_name.to_upper().find("MEMORY") != -1:
		inventory_dict["MEMORY FRAGMENTS"] += 1
	print("Added ", item_name, ": ", inventory_dict)
	
	inventory_updated.emit()  # **发出信号，通知 UI 更新**

func remove_from_inventory(item_name: String):
	if item_name.to_upper() == "KEY" and inventory_dict["KEYS"] > 0:
		inventory_dict["KEYS"] -= 1
	elif item_name.to_upper().find("MEMORY") != -1 and inventory_dict["MEMORY FRAGMENTS"] > 0:
		inventory_dict["MEMORY FRAGMENTS"] -= 1
	print("Removed ", item_name, ": ", inventory_dict)

	inventory_updated.emit()  # **发出信号，通知 UI 更新**
