extends Panel

@onready var boton_menu: TextureButton = $botonMenu
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

#
@onready var panel_superior: Panel = $"."
@onready var boton_esconder_superior: TextureButton = $botonEsconderSuperior

# para ocultar el hud superior
var tween: Tween
var panel_visible: bool = true

# posiciones 
var posicion_oculta : Vector2
var posicion_visible : Vector2
var posicion_boton_visible : Vector2
var posicion_boton_oculta : Vector2

var altura_boton_visible: float = 5


func _ready() -> void:
	empezar_oleada.cambiar_texto("Empezar Oleada " + str(globalJuego.oleada_actual))
	desaparecer_botones_velocidades()
	globalJuego.oleada_cambiada.connect(_actualizar_oleada)
	_actualizar_oleada(globalJuego.oleada_actual)
	imagen_debilidades.texture = load("res://assets/ui/debilidades.png")
	imagen_debilidades.visible=false
	economia.monedas_cambiadas.connect(_actualizar_monedas)
	_actualizar_monedas(economia.monedas_actual)
	
	posicion_visible = panel_superior.position
	posicion_oculta = posicion_visible - Vector2(0, panel_superior.size.y + altura_boton_visible)
	
	posicion_boton_visible = boton_esconder_superior.position
	posicion_boton_oculta = posicion_boton_visible + Vector2(0, panel_superior.size.y + altura_boton_visible)
	
	GlobalSignal.finalizaOleada.connect(finaliza_oleada)


func _actualizar_monedas(nuevas_monedas: int) -> void:
	if !globalJuego.debug:
		monedas_valor.cambiar_texto(str(nuevas_monedas))
	else: 
		monedas_valor.cambiar_texto(" ?")

func _actualizar_oleada(nueva_oleada: int) -> void:
	empezar_oleada.cambiar_texto("Empezar Oleada " + str(nueva_oleada))
	#oleada_label.text = " OLEADA " + str(nueva_oleada)
	
func finaliza_oleada(_valor):
	desaparecer_botones_velocidades()

func _on_boton_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main.tscn")

# aparecer o desaparecer los botones para evitar que se toque mal
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
	
# botones con funciones especiales
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


# boton empezar oleada
func _on_empezar_oleada_pressed() -> void:
	if !globalJuego.empezo_oleada and empezar_oleada.ver_texto() == "Empezar Oleada " + str(globalJuego.oleada_actual):
		globalJuego.empezo_oleada = true
		GlobalSignal.emit_signal("comienzoOleada")
		economia.monedas_antes_oleada = economia.monedas_actual
		aparecer_botones_velocidades()
		Piezas.cancelar_modo_colocacion()
		Piezas.emit_signal("modo_colocacion_cancelado")
	


# botones de velocidad y pausa
func _on_boton_pausar_pressed() -> void:
	GlobalSignal.emit_signal("aceleraMarcaPaso",1)
	GlobalSignal.emit_signal("controlMarcaPaso",false)
	GlobalJuego.juego_pausa = true
	

func _on_boton_play_pressed() -> void:
	GlobalSignal.emit_signal("aceleraMarcaPaso",1)
	GlobalSignal.emit_signal("controlMarcaPaso",true)
	GlobalJuego.juego_pausa = false

func _on_boton_acelerar_1_pressed() -> void:
	GlobalSignal.emit_signal("aceleraMarcaPaso",3)
	GlobalJuego.juego_pausa = false

func _on_boton_acelerar_2_pressed() -> void:
	GlobalSignal.emit_signal("aceleraMarcaPaso",5)
	GlobalJuego.juego_pausa = false
	


func _on_boton_esconder_superior_pressed() -> void:
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween()
	
	if panel_visible:
		_ocultar()
	else:
		_mostrar()
	
	panel_visible = !panel_visible


func _mostrar():
	# Efecto de rebote al mostrar
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)  # BACK crea el efecto rebote

	tween.tween_property(panel_superior, "position", posicion_visible, 0.6)
	

func _ocultar():
	# Efecto suave al ocultar (sin rebote, más rápido)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	
	tween.tween_property(panel_superior, "position", posicion_oculta, 0.4)
	
