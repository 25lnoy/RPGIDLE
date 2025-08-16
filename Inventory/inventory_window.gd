extends Control
#Not my code, got it from a video for help
@export var inventory_data : InventoryData
var current_dragged_item_item : Dictionary

func _process(delta: float) -> void:
	if not has_node("ItemDrag"):
		return
	get_node("ItemDrag").position = get_global_mouse_position() - get_node("ItemDrag"). size / 2

func _ready() -> void:
	update_inventory_data()
	connect_signals()

func connect_signals() -> void:
	GlobalSignals.connect("UpdateInventory", update_inventory_data)

func update_inventory_data() -> void:
	if inventory_data == null:
		return
	for slot in %SlotGroup.get_children():
		slot.queue_free()
	
	for item_data in inventory_data.item_data:
		var new_slot = preload("res://Inventory/Slot.tscn").instantiate()
		new_slot.current_item = item_data
		%SlotGroup.add_child(new_slot)
		
