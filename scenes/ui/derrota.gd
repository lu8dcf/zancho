extends Control

@onready var control: Control = $"."


func _ready() -> void:
	Sonidos.sonar_sfx("derrota")

func _on_reintentar_pressed() -> void:
	control.visible = false
	GlobalJuego.tutorial = false
	GlobalJuego.reiniciar_variables()
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")


func _on_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main.tscn")
	control.visible = false
	
