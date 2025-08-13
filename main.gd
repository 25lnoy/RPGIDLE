extends Control

#storage of each item
@export var wood = 0
var coal = 0
var stone = 0
var userlevel = 0
var userexp = 0



#Runs on startup
func _ready():
	%Stone_timer.timeout.connect(_on_Stone_timer_timeout)
	%wood_timer.timeout.connect(_on_wood_timer_timeout)

#Changes the tab to the selected button
func _on_woodtab_pressed() -> void:
	%WoodTab.visible = true
	%MineTab.visible = false
	%CraftingTab.visible = false
	%InventoryTab.visible = false
	%MasteryTab.visible = false
	%ArenaTab.visible = false

func _on_minetab_pressed() -> void:
	%MineTab.visible = true
	%WoodTab.visible = false
	%CraftingTab.visible = false
	%InventoryTab.visible = false
	%MasteryTab.visible = false
	%ArenaTab.visible = false

func _on_craftingtab_pressed() -> void:
	%MineTab.visible = false
	%WoodTab.visible = false
	%CraftingTab.visible = true
	%InventoryTab.visible = false
	%MasteryTab.visible = false
	%ArenaTab.visible = false
	
func _on_inventory_pressed() -> void:
	%MineTab.visible = false
	%WoodTab.visible = false
	%CraftingTab.visible = false
	%InventoryTab.visible = true
	%MasteryTab.visible = false
	%ArenaTab.visible = false

func _on_MasteryTab_pressed() -> void:
	%MineTab.visible = false
	%WoodTab.visible = false
	%CraftingTab.visible = false
	%InventoryTab.visible = false
	%MasteryTab.visible = true
	%ArenaTab.visible = false

func _on_arena_pressed() -> void:
	%MineTab.visible = false
	%WoodTab.visible = false
	%CraftingTab.visible = false
	%InventoryTab.visible = false
	%MasteryTab.visible = false
	%ArenaTab.visible = true

#Happens constantly from startup
func _process(delta):
	userexp += 3
	if %LevelProgressBar.value >= %LevelProgressBar.max_value:
		Level()
	%level.text = str(userlevel)
	%TempWoodStorageLabel.text = str(wood)
	%TempStoneStorageLabel.text = str(stone)
	%Stone_progress.value = %Stone_timer.time_left
	%wood_progress.value = %wood_timer.time_left
	%LevelProgressBar.value = userexp

#starts the timer when the button is pressed
func _on_wood_button_pressed() -> void:
	if %wood_timer.is_stopped():
		# Start chopping
		%Stone_timer.stop()
		%wood_timer.start(5)
		%wood_button.text = "Cancel Chopping"
	else:
		# Cancel chopping
		%wood_timer.stop()
		%wood_progress.value = 0
		%wood_button.text = "Start Chopping"
		%wood_button.disabled = false
#when the timer ends adds 1 wood to the var
func _on_wood_collect_resource_button_pressed() -> void:
	GlobalSignals.wood_item_data.item_amount += wood
	# Reset local wood to 0 if needed
	wood = 0
	# Emit signal to update UI if you want	
	GlobalSignals.emit_signal("UpdateInventory")

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

func _on_Stone_timer_timeout() -> void:
	stone += 1
	
func _on_stone_collect_resource_button_pressed() -> void:
	GlobalSignals.stone_item_data.item_amount += stone
	# Reset local wood to 0 if needed
	stone = 0
	# Emit signal to update 
	GlobalSignals.emit_signal("UpdateInventory")

func _on_wood_timer_timeout() -> void:
	wood += 1

func Level() -> void:
	%LevelProgressBar.max_value = (%LevelProgressBar.max_value + 10 ) * 1.1
	userexp = 0
	userlevel += 1

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_button_pressed() -> void:
	userexp += 3
