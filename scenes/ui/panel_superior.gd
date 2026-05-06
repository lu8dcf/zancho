extends Panel

@onready var boton_menu = $BotonMenu
@onready var boton_debilidades = $BotonDebilidades
@onready var boton_reiniciar_camera = $BotonReiniciarCamara
@onready var imagen_debilidades = $imagenDebilidades
@onready var empezar_oleada = $empezar_oleada

# botones de velocidades, pausar y continuar
@onready var boton_pausar: TextureButton = $BotonPausar
@onready var boton_play: TextureButton = $BotonPlay
@onready var boton_acelerar_1: TextureButton = $BotonAcelerar1
@onready var boton_acelerar_2: TextureButton = $BotonAcelerar2

# dinero
@onready var monedas_valor: TextureButton = $Monedas_valor


func _ready() -> void:
	empezar_oleada.cambiar_texto("Empezar Oleada " + str(globalJuego.oleada_actual))
	desaparecer_botones_velocidades()
	globalJuego.oleada_cambiada.connect(_actualizar_oleada)
	_actualizar_oleada(globalJuego.oleada_actual)
	imagen_debilidades.texture = load("res://assets/ui/debilidades.png")
	imagen_debilidades.visible=false
	economia.monedas_cambiadas.connect(_actualizar_monedas)
	_actualizar_monedas(economia.monedas_actual)




func _actualizar_monedas(nuevas_monedas: int) -> void:
	if !globalJuego.debug:
		monedas_valor.cambiar_texto(str(nuevas_monedas))
	else: 
		monedas_valor.cambiar_texto(" ?")

func _actualizar_oleada(nueva_oleada: int) -> void:
	empezar_oleada.cambiar_texto("Empezar Oleada " + str(nueva_oleada))
	#oleada_label.text = " OLEADA " + str(nueva_oleada)
	

func _on_boton_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main.tscn")

func desaparecer_botones_velocidades():
	boton_acelerar_1.visible = false
	boton_acelerar_2.visible = false
	boton_play.visible = false
	boton_pausar.visible = false

func aparecer_botones_velocidades():
	boton_acelerar_1.visible = true
	boton_acelerar_2.visible = true
	boton_play.visible = true
	boton_pausar.visible = true
	
	
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
	
	if !globalJuego.empezo_oleada and empezar_oleada.ver_texto() == "Empezar Oleada " + str(globalJuego.oleada_actual):
		globalJuego.empezo_oleada = true
		GlobalSignal.emit_signal("comienzoOleada")
		aparecer_botones_velocidades()


func _on_boton_pausar_pressed() -> void:
	GlobalSignal.emit_signal("aceleraMarcaPaso",1)
	GlobalSignal.emit_signal("controlMarcaPaso",false)
	

func _on_boton_play_pressed() -> void:
	GlobalSignal.emit_signal("controlMarcaPaso",true)
	GlobalSignal.emit_signal("aceleraMarcaPaso",1)


func _on_boton_acelerar_1_pressed() -> void:
	GlobalSignal.emit_signal("aceleraMarcaPaso",3)


func _on_boton_acelerar_2_pressed() -> void:
	GlobalSignal.emit_signal("aceleraMarcaPaso",5)
	
