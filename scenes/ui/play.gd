extends MenuBar


func _on_nueva_partida_pressed() -> void:
	Sonidos.boton1()
	GlobalJuego.tutorial = false
	GlobalJuego.reiniciar_variables()
	LoadManager.cargar_escena("res://scenes/levels/level.tscn") # barra de carga
	#get_tree().change_scene_to_file("res://scenes/levels/level.tscn")
