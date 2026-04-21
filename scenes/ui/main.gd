extends Control







func _on_texture_button_pressed() -> void:
	get_tree().quit()


func _on_texture_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")
