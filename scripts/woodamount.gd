extends Label
var wood = 0

func _process(delta):
	self.text = str(wood)

func _on_button_pressed() -> void:
	wood += 1
