extends Control

@onready var play: MenuBar = $play

@onready var opciones: MenuBar = $opciones

func _ready():
	play.visible=false
	opciones.visible=false


func _on_texture_button_pressed() -> void:
	get_tree().quit()

func esconder_todo():
	play.visible=false
	opciones.visible=false


func _on_texture_button_2_pressed() -> void:
	esconder_todo()
	if play.visible == true:
		play.visible = false
	else:
		play.visible = true

func _on_salir_pressed() -> void:
	get_tree().quit()


func _on_opciones_pressed() -> void:
	esconder_todo()
	if opciones.visible == true:
		opciones.visible = false
	else:
		opciones.visible = true
