extends Control

#storage of each item
var wood = 0
var stone = 0
var userlevel = 0
var userexp = 0
var woodtime = 10
var stonetime = 8
var stickcrafttime = 2
var woodenaxecrafttime = 10
var woodenpickaxecrafttime = 10
var choppingmastery = 0
var choppingmasteryexp = 0
var miningmastery = 0
var miningmasteryexp = 0

func _on_loadbutton_pressed() -> void:
	pass

func _on_savebutton_pressed() -> void:
	pass

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
	_popup_progress_bar_time()
	#when the value of the level reaches the max, it will play the level func
	if %LevelProgressBar.value >= %LevelProgressBar.max_value:
		Level()
	if %ChoppingMasteryProgressbar.value >= %ChoppingMasteryProgressbar.max_value:
		_chopping_mastery()
	if %MiningMasterProgress.value >= %MiningMasterProgress.max_value:
		_mining_mastery()
	%level.text = str(userlevel)
	%TempWoodStorageLabel.text = str(wood)
	%TempStoneStorageLabel.text = str(stone)
	%Stone_progress.value = %Stone_timer.time_left
	%Stone_progress.max_value = %Stone_timer.wait_time
	%wood_progress.max_value = %wood_timer.wait_time
	%wood_progress.value = %wood_timer.time_left
	%LevelProgressBar.value = userexp
	%ChoppingMasteryProgressbar.value = choppingmasteryexp
	%MiningMasterProgress.value = miningmasteryexp
	%ChoppingMasterLevel.text = str(choppingmastery)
	%MiningMasteryLevel.text = str(miningmastery)

func _chopping_mastery() -> void:
	%ChoppingMasteryProgressbar.max_value = (%ChoppingMasteryProgressbar.max_value + 10 ) * 1.1
	choppingmastery += 1
	choppingmasteryexp = 0

func _mining_mastery() -> void:
	%MiningMasteryProgress.max_value = (%MiningMasterProgress.max_value + 10 ) * 1.1
	miningmastery += 1
	miningmasteryexp = 0
#Allow for the popup in crafting to connect the progress bar to the
#timer that is currently needed
func _popup_progress_bar_time() -> void:
	if %CraftPopNameLabel.text == "Wooden Stick":
		%CraftPopProgressBar.max_value = %WoodenStickTimer.wait_time
		%CraftPopProgressBar.value = %WoodenStickTimer.time_left
	if %CraftPopNameLabel.text == "Wooden Axe":
		%CraftPopProgressBar.value = %WoodenAxeCraftTimer.time_left
		%CraftPopProgressBar.max_value = %WoodenAxeCraftTimer.wait_time
	if %CraftPopNameLabel.text == "Wooden Pickaxe":
		%CraftPopProgressBar.value = %WoodenPickCraftTimer.time_left
		%CraftPopProgressBar.max_value = %WoodenPickCraftTimer.wait_time
	
func _user_level_crafting() -> void:
	#Sets the level you need to be to craft a item
	if choppingmastery < 1:
		%StickCraftButton.text = "Require Chopping Mastery 1"
		%StickCraftButton.disabled = true
	else:
		%StickCraftButton.disabled = false
		%StickCraftButton.text = "Wooden Sticks"
	if choppingmastery < 2:
		%WoodenAxeCraftButton.text = "Require Chopping Mastery 2"
		%WoodenAxeCraftButton.disabled = true
	else:
		%WoodenAxeCraftButton.disabled = false
		%WoodenAxeCraftButton.text = "Wooden Axe"
	if choppingmastery < 4:
		%WoodenPickCraftButton.text = "Require Chopping Mastery 4"
		%WoodenPickCraftButton.disabled = true
	else:
		%WoodenPickCraftButton.disabled = false
		%WoodenPickCraftButton.text = "Wooden Pickaxe"

#Allows for tool buffls by shortening the time for chopping trees
func _tool_buffs() -> void:
	if GlobalSignals.wooden_axe_data.item_amount == 1:
		woodtime = 8
	if GlobalSignals.wooden_pickaxe_data.item_amount == 1:
		stonetime = 2
		%Stone_button.disabled = false
		if %Stone_timer.is_stopped():
			%Stone_button.text = "Start Mining"
		else:
			%Stone_button.text = "Mining..."
	else:
		%Stone_button.disabled = true
		%Stone_button.text = "Requires Pickaxe"

#starts the timer when the button is pressed
func _on_wood_button_pressed() -> void:
	if %wood_timer.is_stopped():
		# Start chopping
		%Stone_timer.stop()
		%WoodenStickTimer.stop()
		%WoodenAxeCraftTimer.stop()
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
	wood += choppingmasteryexp
	# Reset local wood to 0 if needed
	wood = 0
	# Emit signal to update UI if you want	
	GlobalSignals.emit_signal("UpdateInventory")

#starts the timer when the button is pressed
func _on_stone_button_pressed() -> void:
	if %Stone_timer.is_stopped():
		# Start chopping
		%wood_timer.stop()
		%WoodenStickTimer.stop()
		%WoodenAxeCraftTimer.stop()
		%Stone_timer.start(stonetime)
		%Stone_button.text = "Cancel Mining"
	else:
		# Cancel chopping
		%Stone_timer.stop()
		%Stone_progress.value = 0
		%Stone_button.text = "Start Mining"
		%Stone_button.disabled = false

#when the timer ends adds 1 stone to the var
func _on_Stone_timer_timeout() -> void:
	stone += 1


#when the button is pressed adds stone var to inventory
func _on_stone_collect_resource_button_pressed() -> void:
	GlobalSignals.stone_item_data.item_amount += stone
	miningmasteryexp += stone
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

#Opens up the popup panel with the data for Wooden sticks
func _on_stick_craft_button_pressed() -> void:
	%CraftPopUp.visible = true
	%CraftPopNameLabel.text = "Wooden Stick"
	%CraftPopItemImage.texture = load("res://Sprites/download (3).jpeg")
	%CraftPopAmountNeedLabel.text = "Required:
	Wood = 2"
	%CraftPopCurrentAmount.text = "Owned:\n" \
		+ "Wood = " + str(GlobalSignals.wood_item_data.item_amount)
	%CurrentOwnedLabel.text = "Owned:\n" \
		+ "Sticks = " + str(GlobalSignals.wooden_sticks_data.item_amount) + "\n"

#When the button is pushed and the name of the panel
#is Wooden Stick, it will run this function
func _wood_stick_craft() -> void:
	if GlobalSignals.wood_item_data.item_amount >= 4:
		if %WoodenStickTimer.is_stopped():
			%WoodenStickTimer.start(stickcrafttime)
			%CraftPopButton.text = "Crafting..."
		else:
			%WoodenStickTimer.stop()
			%CraftPopButton.text = "Craft"

#When the button is pushed it will run the func if it is the right name
func _craft_pop_button_pressed() -> void:
	%wood_timer.stop()
	%Stone_button.text = "Start Mining"
	%Stone_timer.stop()
	%wood_button.text = "Start Chopping"
	if %CraftPopNameLabel.text == "Wooden Stick":
		_wood_stick_craft()
	if %CraftPopNameLabel.text == "Wooden Axe":
		_wooden_axe_craft()
	if %CraftPopNameLabel.text == "Wooden Pickaxe":
		_wooden_pick_craft()

#Updates the labels on the Popup panel so that the numbers are live.
func _update_current_amount() -> void:
	if %CraftPopNameLabel.text == "Wooden Stick":
		%CurrentOwnedLabel.text = "Owned:\n" \
			+ "Sticks = " + str(GlobalSignals.wooden_sticks_data.item_amount) + "\n"
		%CraftPopCurrentAmount.text = "Owned:\n" \
			+ "Wood = " + str(GlobalSignals.wood_item_data.item_amount) + "\n"
	if %CraftPopNameLabel.text == "Wooden Axe":
		%CraftPopCurrentAmount.text = "Owned:\n" \
			+ "Wood = " + str(GlobalSignals.wood_item_data.item_amount) + "\n" \
			+ "Sticks = " + str(GlobalSignals.wooden_sticks_data.item_amount)
		%CurrentOwnedLabel.text = "Owned:\n" \
			+ "Wooden Axes = " + str(GlobalSignals.wooden_axe_data.item_amount) + "\n"
	if %CraftPopNameLabel.text == "Wooden Pickaxe":
		%CraftPopCurrentAmount.text = "Owned:\n" \
			+ "Wood = " + str(GlobalSignals.wood_item_data.item_amount) + "\n" \
			+ "Sticks = " + str(GlobalSignals.wooden_sticks_data.item_amount)
		%CurrentOwnedLabel.text = "Owned:\n" \
			+ "Wooden Pickaxes = " + str(GlobalSignals.wooden_pickaxe_data.item_amount) + "\n"

#When the timer goes off it will do the crafting process
func _on_wooden_stick_timer_timeout() -> void:
	if GlobalSignals.wood_item_data.item_amount >= 2:
		GlobalSignals.wood_item_data.item_amount -= 2
		GlobalSignals.wooden_sticks_data.item_amount += 1
		GlobalSignals.emit_signal("UpdateInventory")
		_update_current_amount()
		#%WoodenStickTimer.stop()
	else:
		%WoodenStickTimer.stop()
		%StickCraftButton.text = "Craft Wooden Stick"

#Sets the Popup panel data
func _on_wooden_axe_craft_button_pressed() -> void:
	%CraftPopUp.visible = true
	%CraftPopNameLabel.text = "Wooden Axe"
	%CraftPopItemImage.texture = load("res://Sprites/download (4).jpeg")
	%CraftPopAmountNeedLabel.text = "Required:
	Wood = 12
	Stick = 4"
	%CraftPopCurrentAmount.text = "Owned:\n" \
		+ "Wood = " + str(GlobalSignals.wood_item_data.item_amount) + "\n" \
		+ "Sticks = " + str(GlobalSignals.wooden_sticks_data.item_amount)
	%CurrentOwnedLabel.text = "Owned:\n" \
		+ "Wooden Axes = " + str(GlobalSignals.wooden_axe_data.item_amount) + "\n"


#cheacks if you have enough items and will start the timer and change label text
func _wooden_axe_craft() -> void:
	if GlobalSignals.wood_item_data.item_amount >= 12 and GlobalSignals.wooden_sticks_data.item_amount >= 4:
		if %WoodenAxeCraftTimer.is_stopped():
			%WoodenAxeCraftTimer.start(woodenaxecrafttime)
			%CraftPopButton.text = "Crafting..."
		else:
			%WoodenAxeCraftTimer.stop()
			%CraftPopButton.text = "Craft"
#When the timer ends adds items to invertory and take away
func _on_wooden_axe_craft_timer_timeout() -> void:
	if GlobalSignals.wood_item_data.item_amount >= 12 and GlobalSignals.wooden_sticks_data.item_amount >= 4:
		GlobalSignals.wood_item_data.item_amount -= 12
		GlobalSignals.wooden_sticks_data.item_amount -= 4
		GlobalSignals.wooden_axe_data.item_amount += 1
		GlobalSignals.emit_signal("UpdateInventory")
		_update_current_amount()
	else:
		%WoodenAxeCraftTimer.stop()
		%WoodenAxeCraftButton.text = "Wooden Axe"


func _on_wooden_pick_craft_button_pressed() -> void:
	%CraftPopUp.visible = true
	%CraftPopNameLabel.text = "Wooden Pickaxe"
	%CraftPopItemImage.texture = load("res://Sprites/images (1).png")
	%CraftPopAmountNeedLabel.text = "Required:
	Wood = 20
	Stick = 8"
	%CraftPopCurrentAmount.text = "Owned:\n" \
		+ "Wood = " + str(GlobalSignals.wood_item_data.item_amount) + "\n" \
		+ "Sticks = " + str(GlobalSignals.wooden_sticks_data.item_amount)
	%CurrentOwnedLabel.text = "Owned:\n" \
		+ "Wooden Pickaxes = " + str(GlobalSignals.wooden_pickaxe_data.item_amount) + "\n"


func _wooden_pick_craft() -> void:
	if GlobalSignals.wood_item_data.item_amount >= 20 and GlobalSignals.wooden_sticks_data.item_amount >= 8:
		if %WoodenPickCraftTimer.is_stopped():
			%WoodenPickCraftTimer.start(woodenpickaxecrafttime)
			%CraftPopButton.text = "Crafting..."
		else:
			%WoodenPickCraftTimer.stop()
			%CraftPopButton.text = "Craft"

func _on_wooden_pick_craft_timer_timeout() -> void:
	if GlobalSignals.wood_item_data.item_amount >= 20 and GlobalSignals.wooden_sticks_data.item_amount >= 8:
		GlobalSignals.wood_item_data.item_amount -= 20
		GlobalSignals.wooden_sticks_data.item_amount -= 8
		GlobalSignals.wooden_pickaxe_data.item_amount += 1
		GlobalSignals.emit_signal("UpdateInventory")
		_update_current_amount()
		%WoodenPickCraftTimer.stop()
		%CraftPopButton.text = "Craft"
