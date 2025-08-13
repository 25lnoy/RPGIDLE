extends Control


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gui.tscn")


func _on_options_button_pressed() -> void:
	%MainMenuSets.visible = false
	%OptionsContainer.visible = true


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_back_options_pressed() -> void:
	%MainMenuSets.visible = true
	%OptionsContainer.visible = false
