extends MenuBar


func _on_nueva_partida_pressed() -> void:
	Sonidos.boton1()
	
	globalJuego.reiniciar_variables()
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")
