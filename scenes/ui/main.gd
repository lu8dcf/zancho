extends Control

@onready var play: MenuBar = $play


func _ready():
	play.visible=false



func _on_texture_button_pressed() -> void:
	get_tree().quit()




func _on_texture_button_2_pressed() -> void:
	if play.visible == true:
		play.visible = false
	else:
		play.visible = true

func _on_salir_pressed() -> void:
	get_tree().quit()
