extends Control
#stoeage of each item
var wood = 0
var coal = 0
var stone = 0

#Runs on startup
func _ready():
	%coal_timer.timeout.connect(_on_coal_timer_timeout)
	%stone_timer.timeout.connect(_on_stone_timer_timeout)
	%wood_timer.timeout.connect(_on_wood_timer_timeout)
#Changes the tab to the selected button
func _on_woodtab_pressed() -> void:
	get_node("wood_tab").visible = true
	get_node("mines_tab").visible = false
	get_node("Crafting_tab").visible = false
	get_node("Inventory_tab").visible = false

func _on_minetab_pressed() -> void:
	get_node("mines_tab").visible = true
	get_node("wood_tab").visible = false
	get_node("Crafting_tab").visible = false
	get_node("Inventory_tab").visible = false

func _on_craftingtab_pressed() -> void:
	get_node("Crafting_tab").visible = true
	get_node("wood_tab").visible = false
	get_node("mines_tab").visible = false
	get_node("Inventory_tab").visible = false
	
func _on_inventory_pressed() -> void:
	get_node("Crafting_tab").visible = false
	get_node("wood_tab").visible = false
	get_node("mines_tab").visible = false
	get_node("Inventory_tab").visible = true

#Happens constantly from startup
func _process(delta):
	get_node("wood_tab/wood_panel/wood_amount").text = str(wood)
	get_node("mines_tab/coal_panel/coal_amount").text = str(coal)
	get_node("mines_tab/stone_panel/stone_amount").text = str(stone)
	%coal_progress.value = %coal_timer.time_left
	%stone_progress.value = %stone_timer.time_left
	%wood_progress.value = %wood_timer.time_left
#starts the timer when the button is pressed
func _on_wood_button_pressed() -> void:
	if %wood_timer.is_stopped():
		# Start chopping
		%wood_timer.start(5)
		%wood_button.text = "Cancel Chopping"
	else:
		# Cancel chopping
		%wood_timer.stop()
		%wood_progress.value = 0
		%wood_button.text = "Start Chopping"
		%wood_button.disabled = false
#when the timer ends adds 1 wood to the var
func _on_wood_timer_timeout() -> void:
	wood += 1

func _on_coal_button_pressed() -> void:
	%stone_timer.stop()
	if %coal_timer.is_stopped():
		# Timer is not running: Start mining
		%coal_timer.start(5)
		get_node("mines_tab/coal_panel/coal_button").text = "Cancel Mining"
	else:
		# Timer is running: Stop mining
		%coal_timer.stop()
		%coal_progress.value = 0
		get_node("mines_tab/coal_panel/coal_button").text = "Mine Coal"
		get_node("mines_tab/coal_panel/coal_button").disabled = false 

func _on_coal_timer_timeout() -> void:
	coal += 1
	
func _on_stone_button_pressed() -> void:
	%coal_timer.stop()
	if %stone_timer.is_stopped():
		%stone_timer.start(5)
		get_node("mines_tab/stone_panel/stone_button").text = "Cancel Mining"
	else:
		%stone_timer.stop()
		%stone_progress.value = 0
		get_node("mines_tab/stone_panel/stone_button").text = "Mine Coal"
		get_node("mines_tab/stone_panel/stone_button").disabled = false  # Optional, just in case

func _on_stone_timer_timeout() -> void:
	stone += 1
