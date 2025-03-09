extends Control

@onready var inventory_display = $VBoxContainer
var labels = {}  # 存储 Label 引用

func _ready():
	# 监听 Inventory 单例的信号
	Inventory.inventory_updated.connect(update_inventory_display)

	# **初始化 UI**
	update_inventory_display()

func update_inventory_display():
	# **确保 UI 同步 inventory_dict**
	for item_name in Inventory.inventory_dict.keys():
		if item_name in labels:
			# 更新 Label 文本
			labels[item_name].text = item_name + ": " + str(Inventory.inventory_dict[item_name])
		else:
			# **创建新 Label 并添加到 UI**
			var item_label = Label.new()
			item_label.name = item_name
			item_label.text = item_name + ": " + str(Inventory.inventory_dict[item_name])
			inventory_display.add_child(item_label)
			labels[item_name] = item_label
	
	inventory_display.queue_redraw()  # 强制 UI 重新渲染
