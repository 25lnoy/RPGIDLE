extends Control

#storage of each item
@export var wood = 0
var coal = 0
var stone = 0
var userlevel = 6
var userexp = 0
var woodtime = 10



#Runs on startup
func _ready():
	%Stone_timer.timeout.connect(_on_Stone_timer_timeout)
	%wood_timer.timeout.connect(_on_wood_timer_timeout)

#Changes the tab to the selected button
func _on_woodtab_pressed() -> void:
	if %WoodTab.is_visible_in_tree():
		%WoodTab.visible = false
	else:
		%WoodTab.visible = true
		%MineTab.visible = false
		%CraftingTab.visible = false
		%InventoryTab.visible = false
		%MasteryTab.visible = false
		%ArenaTab.visible = false

func _on_minetab_pressed() -> void:
	if %MineTab.is_visible_in_tree():
		%MineTab.visible = false
	else:
		%MineTab.visible = true
		%WoodTab.visible = false
		%CraftingTab.visible = false
		%InventoryTab.visible = false
		%MasteryTab.visible = false
		%ArenaTab.visible = false

func _on_craftingtab_pressed() -> void:
	if %CraftingTab.is_visible_in_tree():
		%CraftingTab.visible = false
	else:
		%MineTab.visible = false
		%WoodTab.visible = false
		%CraftingTab.visible = true
		%InventoryTab.visible = false
		%MasteryTab.visible = false
		%ArenaTab.visible = false
	
func _on_inventory_pressed() -> void:
	if %InventoryTab.is_visible_in_tree():
		%InventoryTab.visible = false
	else:
		%MineTab.visible = false
		%WoodTab.visible = false
		%CraftingTab.visible = false
		%InventoryTab.visible = true
		%MasteryTab.visible = false
		%ArenaTab.visible = false

func _on_MasteryTab_pressed() -> void:
	if %MasteryTab.is_visible_in_tree():
		%MasteryTab.visible = false
	else:
		%MineTab.visible = false
		%WoodTab.visible = false
		%CraftingTab.visible = false
		%InventoryTab.visible = false
		%MasteryTab.visible = true
		%ArenaTab.visible = false

func _on_arena_pressed() -> void:
	if %ArenaTab.is_visible_in_tree():
		%ArenaTab.visible = false
	else:
		%MineTab.visible = false
		%WoodTab.visible = false
		%CraftingTab.visible = false
		%InventoryTab.visible = false
		%MasteryTab.visible = false
		%ArenaTab.visible = true

#Happens constantly from startup
func _process(delta):
	_user_level_crafting()
	_tool_buffs()
	#when the value of the level reaches the max, it will play the level func
	if %LevelProgressBar.value >= %LevelProgressBar.max_value:
		Level()
	%level.text = str(userlevel)
	%TempWoodStorageLabel.text = str(wood)
	%TempStoneStorageLabel.text = str(stone)
	%Stone_progress.value = %Stone_timer.time_left
	%WoodenStickProgressbar.value = %WoodenStickTimer.time_left
	%WoodenAxeCraftProgress.value = %WoodenAxeCraftTimer.time_left
	%wood_progress.max_value = %wood_timer.wait_time
	%wood_progress.value = %wood_timer.time_left
	%LevelProgressBar.value = userexp

func _user_level_crafting() -> void:
	#Sets the level you need to be to craft a item
	if userlevel < 5:
		%StickCraftButton.text = "Require Level 5"
		%StickCraftButton.disabled = true
	else:
		%StickCraftButton.disabled = false
		%StickCraftButton.text = "Wooden Sticks"
	if userlevel < 6:
		%WoodenAxeCraftButton.text = "Require Level 6"
		%WoodenAxeCraftButton.disabled = true
	else:
		%WoodenAxeCraftButton.disabled = false
		%WoodenAxeCraftButton.text = "Wooden Axe"
	if userlevel < 8:
		%WoodenPickCraftButton.text = "Require Level 8"
		%WoodenPickCraftButton.disabled = true
	else:
		%WoodenPickCraftButton.disabled = false
		%WoodenPickCraftButton.text = "Wooden Pickaxe"

func _tool_buffs() -> void:
	if GlobalSignals.wooden_axe_data.item_amount == 1:
		print(woodtime)
		woodtime = 

#starts the timer when the button is pressed
func _on_wood_button_pressed() -> void:
	if %wood_timer.is_stopped():
		# Start chopping
		%Stone_timer.stop()
		%wood_timer.start(woodtime)
		%wood_button.text = "Cancel Chopping"
	else:
		# Cancel chopping
		%wood_timer.stop()
		%wood_progress.value = 0
		%wood_button.text = "Start Chopping"
		%wood_button.disabled = false
#when the button is pressed adds wood var to inventory
func _on_wood_collect_resource_button_pressed() -> void:
	GlobalSignals.wood_item_data.item_amount += wood
	# Reset local wood to 0 if needed
	wood = 0
	# Emit signal to update UI if you want	
	GlobalSignals.emit_signal("UpdateInventory")
#starts the timer when the button is pressed
func _on_stone_button_pressed() -> void:
	if %Stone_timer.is_stopped():
		# Start chopping
		%wood_timer.stop()
		%Stone_timer.start(5)
		%Stone_button.text = "Cancel Mining"
	else:
		# Cancel chopping
		%Stone_timer.stop()
		%Stone_progress.value = 0
		%Stone_button.text = "Start Chopping"
		%Stone_button.disabled = false
#when the timer ends adds 1 stone to the var
func _on_Stone_timer_timeout() -> void:
	stone += 1
	#when the button is pressed adds stone var to inventory
func _on_stone_collect_resource_button_pressed() -> void:
	GlobalSignals.stone_item_data.item_amount += stone
	# Reset local stone to 0 if needed
	stone = 0
	# Emit signal to update 
	GlobalSignals.emit_signal("UpdateInventory")
#when the timer ends adds 1 wood to the var
func _on_wood_timer_timeout() -> void:
	wood += 1
#When user level progress bar reached max, calculates the next levels exp

func Level() -> void:
	%LevelProgressBar.max_value = (%LevelProgressBar.max_value + 10 ) * 1.1
	userexp = 0
	#adds 1 level to player
	userlevel += 1
#Opens the are you sure and allows to leave
func _on_quit_button_pressed() -> void:
	%SaveandQuit.visible = true
#Takes user to main menu
func _on_yes_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

#Closes are you sure tab and back to game
func _on_no_button_pressed() -> void:
	%SaveandQuit.visible = false


func _on_stick_craft_button_pressed() -> void:
	if GlobalSignals.wood_item_data.item_amount >= 4:
		if %WoodenStickTimer.is_stopped():
			%WoodenStickTimer.start(5)
			%StickCraftButton.text = "Crafting..."
		else:
			%WoodenStickTimer.stop()
			%StickCraftButton.text = "Wooden Stick"


func _on_wooden_stick_timer_timeout() -> void:
	if GlobalSignals.wood_item_data.item_amount >= 4:
		GlobalSignals.wood_item_data.item_amount -= 4
		GlobalSignals.wooden_sticks_data.item_amount += 1
		GlobalSignals.emit_signal("UpdateInventory")
	else:
		%WoodenStickTimer.stop()
		%StickCraftButton.text = "Craft Wooden Stick"

func _on_wooden_axe_craft_button_pressed() -> void:
	if GlobalSignals.wood_item_data.item_amount >= 12 and GlobalSignals.wooden_sticks_data.item_amount >= 4:
		if %WoodenAxeCraftTimer.is_stopped():
			%WoodenAxeCraftTimer.start(5)
			%WoodenAxeCraftButton.text = "Crafting..."
		else:
			%WoodenAxeCraftTimer.stop()
			%WoodenAxeCraftButton.text = "Craft Wooden Axe"

func _on_wooden_axe_craft_timer_timeout() -> void:
	if GlobalSignals.wood_item_data.item_amount >= 12 and GlobalSignals.wooden_sticks_data.item_amount >= 4:
		GlobalSignals.wood_item_data.item_amount -= 12
		GlobalSignals.wooden_sticks_data.item_amount -= 4
		GlobalSignals.wooden_axe_data.item_amount += 1
		GlobalSignals.emit_signal("UpdateInventory")
		%WoodenAxeCraftTimer.stop()
	else:
		%WoodenAxeCraftTimer.stop()
		%WoodenAxeCraftButton.text = "Wooden Axe"


func _on_button_pressed() -> void:
	userexp += 3
