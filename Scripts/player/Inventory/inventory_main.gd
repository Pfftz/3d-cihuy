extends Node

@export var inventory_size = 24
@onready var grid = get_node("grid")

func _ready():
	for i in range(inventory_size):
		var slot = InventorySlot.new()
		slot.init(ItemData.Type.MAIN, Vector2(32, 32))
		grid.add_child(slot)
	add_item("Iron Sword")
	add_item("Long Sword")
	add_item("Small Potion")

func add_item(item_name: String):
	var item = InventoryItem.new()
	item.init(Game.items[item_name])
	if item.data.stackable:
		for i in inventory_size:
			if grid.get_child(i).get_child_count() > 0:
				if grid.get_child(i).get_child(0).data == item.data:
					#update the counter
					grid.get_child(i).get_child(0).data.count += 1
					#update the label counter
					grid.get_child(i).get_child(0).get_child(0).text = str(grid.get_child(i).get_child(0).data.count)
					break
				else:
					grid.get_child(i).add_child(item)
					break
	else:		
		for i in inventory_size:
			if grid.get_child(i).get_child_count() == 0:
				grid.get_child(i).add_child(item)
				break
