extends Control

@export var inventory_dict = {"KEYS":1,"MEMORY FRAGMENTS":0}
# Called when the node enters the scene tree for the first time.
var inventory_display   # 先创建一个 VBoxContainer 作为子节点
var labels = {}  # 用来存储现有的 Label
func _ready() -> void:
	inventory_display = get_node_or_null("VBoxContainer")
	if inventory_display == null:
		inventory_display = VBoxContainer.new()
		inventory_display.name = "VBoxContainer"
		add_child(inventory_display)  # 将 VBoxContainer 添加到 Inventory 节点
		# 初始化所有的 Label
		for item_name in inventory_dict.keys():
			var item_label = Label.new()
			item_label.text = item_name + ": " + str(inventory_dict[item_name])
			inventory_display.add_child(item_label)
			labels[item_name] = item_label  # 将标签存入字典中
	update_inventory_display()

func update_inventory_display():
	var key_label = Label.new()
	
	for item_name in inventory_dict.keys():
		# 如果已经存在，直接更新文本
		labels[item_name].text = item_name + ": " + str(inventory_dict[item_name])
		print(labels[item_name].text)
		print_inventory_display_children()
	

func print_inventory_display_children():
	print("Inventory Display Children:")
	for child in inventory_display.get_children():
		print(child.name)  # 打印每个子节点的名字
		
func add_to_inventory(item_name: String):
	if (item_name.to_upper() == "KEY"):
		inventory_dict["KEYS"]+=1
	elif item_name.to_upper().find("MEMORY") != -1:
		inventory_dict["MEMORY FRAGMENTS"]+=1
	print("Added ", item_name, ": ", inventory_dict)
	
	update_inventory_display()
	
func remove_from_inventory(item_name: String):
	if (item_name.to_upper() == "KEY") and inventory_dict["KEYS"] > 0:
		inventory_dict["KEYS"]-=1
	elif (item_name.to_upper().find("MEMORY") != -1)and inventory_dict["MEMORY FRAGMENTS"] > 0:
		inventory_dict["MEMORY FRAGMENTS"]-=1
	
	update_inventory_display()
		
