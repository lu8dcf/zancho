extends Control

@onready var control: Control = $"."


func _on_reintentar_pressed() -> void:
	GlobalJuego.perder_fe(5)
	control.visible = false


func _on_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main.tscn")
	control.visible = false
	
