extends TextureButton


func _on_mouse_entered() -> void:
	Sonidos.hover()


func _on_pressed() -> void:
	Sonidos.boton1()
