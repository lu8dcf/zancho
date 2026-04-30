extends Panel

@onready var boton_menu = $BotonMenu
@onready var boton_debilidades = $BotonDebilidades
@onready var boton_reiniciar_camera = $BotonReiniciarCamara
@onready var imagen_debilidades = $imagenDebilidades
@onready var empezar_oleada: Button = $empezar_oleada
@onready var acelerar: Button = $acelerar

func _ready() -> void:
	empezar_oleada.text = "Empezar Oleada " + str(globalJuego.oleada_actual)
	acelerar.text = "x1"
	globalJuego.oleada_cambiada.connect(_actualizar_oleada)
	_actualizar_oleada(globalJuego.oleada_actual)
	imagen_debilidades.texture = load("res://assets/ui/debilidades.png")
	imagen_debilidades.visible=false



func _actualizar_oleada(nueva_oleada: int) -> void:
	empezar_oleada.text = "Empezar Oleada " + str(nueva_oleada)
	#oleada_label.text = " OLEADA " + str(nueva_oleada)
	

func _on_boton_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main.tscn")


func _on_boton_reiniciar_camara_pressed() -> void:
	var camara = get_tree().root.find_child("ControlCamara", true, false)
	
	if camara and camara is Node3D:
		camara.reiniciar_posicion()

	#mapas.siguiente_mapa()

func _on_boton_debilidades_pressed() -> void:
	if imagen_debilidades.visible:
		imagen_debilidades.visible = false
	else:
		imagen_debilidades.visible = true	


func _on_empezar_oleada_pressed() -> void:
	globalJuego.empezo_oleada = true
	# falta llamar a la globalSignal de empezar la oleada
	if globalJuego.empezo_oleada and empezar_oleada.text == "Empezar Oleada " + str(globalJuego.oleada_actual):
		GlobalSignal.emit_signal("comienzoOleada")
		empezar_oleada.text = "Pausar Oleada " + str(globalJuego.oleada_actual)
	elif globalJuego.empezo_oleada and empezar_oleada.text == "Pausar Oleada " + str(globalJuego.oleada_actual):
		GlobalSignal.emit_signal("controlMarcaPaso",false)
		empezar_oleada.text = "Continuar Oleada " + str(globalJuego.oleada_actual)
	elif globalJuego.empezo_oleada and empezar_oleada.text == "Continuar Oleada " + str(globalJuego.oleada_actual):
		empezar_oleada.text = "Pausar Oleada " + str(globalJuego.oleada_actual)
		GlobalSignal.emit_signal("controlMarcaPaso",true)


func _on_acelerar_pressed() -> void:
	if acelerar.text == "x1":
		acelerar.text = "x2"
	else:
		acelerar.text = "x1"
