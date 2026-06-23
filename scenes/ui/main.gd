extends Control

@onready var play: MenuBar = $play
@onready var creditos: TextureRect = $creditos
@onready var creditosanim: AnimationPlayer = $creditos/creditos

@onready var opciones: MenuBar = $opciones
@onready var recompensa: Control = $recompensa


func _ready():

	play.visible=false
	opciones.visible=false
	recompensa.visible = true
	Sonidos.menu(true)
	creditos.visible = false
	

func esconder_todo():
	play.visible=false
	opciones.visible=false
	recompensa.visible = true
	creditos.visible = false
	creditosanim.stop(true)
	
func _on_texture_button_2_pressed() -> void:
	Sonidos.boton1()
	esconder_todo()
	if play.visible == true:
		play.visible = false
	else:
		play.visible = true

func _on_salir_pressed() -> void:
	Sonidos.boton1()
	get_tree().quit()


func _on_opciones_pressed() -> void:
	Sonidos.boton1()
	esconder_todo()
	if opciones.visible == true:
		opciones.visible = false
	else:
		opciones.visible = true


func _on_play_mouse_entered() -> void:
	Sonidos.hover()


func _on_salir_focus_entered() -> void:
	Sonidos.hover()


func _on_creditos_mouse_entered() -> void:
	Sonidos.hover()
	


func _on_opciones_mouse_entered() -> void:
	Sonidos.hover()


func _on_como_jugar_pressed() -> void:
	Sonidos.boton1()
	GlobalJuego.tutorial = true
	GlobalJuego.debug = false
	GlobalJuego.reiniciar_variables()
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")


func _on_creditos_pressed() -> void:
	esconder_todo()
	creditos.visible = true
	creditosanim.play("creditos")
