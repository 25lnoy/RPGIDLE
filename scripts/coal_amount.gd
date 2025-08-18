extends Label
var coal = 0

func _process(delta):
	self.text = str(coal)

func _on_coal_button_pressed() -> void:
	coal += 1
