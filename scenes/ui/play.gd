extends MenuBar


func _on_nueva_partida_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")
