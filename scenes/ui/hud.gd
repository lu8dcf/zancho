extends CanvasLayer

# panel inferior
@onready var panel_inferior: Panel = $PanelInferior
@onready var imagen_back_inferior: TextureRect = $imagenBackInferior
@onready var panel_rey: Panel = $imagenBackInferior/PanelRey

# contenedor de log
@onready var log_texto: RichTextLabel = $ContenedorLog/Log

var max_mensajes: int = 50

# panel superior
@onready var panel_superior: Panel = $PanelSuperior

# texto debug
@onready var label_debug_temporal: Label = $Label_debug_temporal


# escenas de victoria/derrota
@export var escena_victoria: PackedScene = preload("res://scenes/ui/components/ganaste_oleada.tscn")
@export var escena_derrota: PackedScene = preload("res://scenes/ui/components/perdiste_oleada.tscn")

#tutorial
@onready var pantallaNegra = $blackOut
# -------------------------------------------------------------

var tween: Tween

func _ready():
	mostrar_todos_paneles()
	if GlobalJuego.debug:
		label_debug_temporal.text = "Debug: " + str(GlobalJuego.debug)
	else:
		label_debug_temporal.visible = false
	log_texto.bbcode_enabled = true
	log_texto.scroll_active = false
	
	# conectar señales
	GlobalSignal.finalizaOleada.connect(mostrar_imagen)
	GlobalSignal.mensaje_oleada.connect(mensaje_oleada_log)
	GlobalSignal.mensaje_tienda.connect(mensaje_tienda_log)
	GlobalSignal.finAtaque.connect(mensaje_muerte_log)
	Piezas.pieza_colocada.connect(mensaje_colocacion_log)

func mostrar_todos_paneles():
	panel_inferior.visible = true
	panel_superior.visible = true
	panel_rey.visible = true
	
func mostrar_imagen(ganar: int) -> void:
	GlobalJuego.empezo_oleada = false
	$PanelTienda._ocultar_tienda()
	#si es el tutorial:
	if (GlobalJuego.tutorial):
		pantallaNegra.visible = true
		var tweenTutorial = create_tween()
		tweenTutorial.tween_property(pantallaNegra, "modulate", Color(0.0, 0.0, 0.0, 1), 1.5)
		await get_tree().create_timer(3).timeout
		GlobalSignal.emit_signal("PantallaNegra")
	else:
		if ganar:
			if escena_victoria:
				var instancia_victoria = escena_victoria.instantiate()
				add_child(instancia_victoria)
			#mostras_desaparecer_imagen()
			#GlobalJuego.siguiente_oleada()
		else:
			if escena_derrota:
				var instancia_derrota = escena_derrota.instantiate()
				add_child(instancia_derrota)
			#mostras_desaparecer_imagen()
			#GlobalJuego.perder_fe(5)

# signal mensaje_oleada(empieza:bool,gano:bool) 
func mensaje_oleada_log(empieza: bool, gano_oleada = null):
	var texto_completo = ""
	var tipo = null
	if empieza:
		texto_completo = "Empieza la Oleada " + str(GlobalJuego.oleada_actual)
		tipo = 2
	else:
		texto_completo = "Terminó la Oleada " + str(GlobalJuego.oleada_actual)
		if gano_oleada:
			tipo = 1
			texto_completo += " ¡Ganaste!"
		else:
			tipo = 0
			texto_completo += " ¡Perdiste! Tus piezas pierden Fé"
	actualizar_log(texto_completo, tipo)
			
func mensaje_tienda_log(compra: bool, nombre_pieza: String):
	var texto_completo = ""
	var tipo = 3
	if compra:
		texto_completo = "Compraste " + nombre_pieza
	else:
		texto_completo = "Vendiste " + nombre_pieza
	actualizar_log(texto_completo, tipo)

func mensaje_colocacion_log(tipo_pieza: int, posicion: Vector2i):
	var nombre_pieza = economia.obtener_nombre_pieza(tipo_pieza)
	var texto_completo = "Colocaste la pieza " + nombre_pieza + " en n: " + str(posicion)
	actualizar_log(texto_completo, 4)

func mensaje_muerte_log(gano_pelea: int, color: bool, perdio_pelea: int):
	var pieza_ganadora = economia.obtener_nombre_pieza(gano_pelea)
	var pieza_perdedora = economia.obtener_nombre_pieza(perdio_pelea)
	var texto_completo = ""
	if Piezas.color_piezas: #true = blancas
		if color:
			texto_completo = pieza_ganadora + " blanco mató a " + pieza_perdedora
			if pieza_ganadora == "Torre" or pieza_ganadora == "Reina":
				texto_completo = pieza_ganadora + " blanca mató a " + pieza_perdedora
				
		else:
			texto_completo = pieza_ganadora + " negro mató a " + pieza_perdedora
			if pieza_ganadora == "Torre" or pieza_ganadora == "Reina":
				texto_completo = pieza_ganadora + " negra mató a " + pieza_perdedora
	else:
		if color:
			texto_completo = pieza_ganadora + " negro mató a " + pieza_perdedora
			if pieza_ganadora == "Torre" or pieza_ganadora == "Reina":
				texto_completo = pieza_ganadora + " negra mató a " + pieza_perdedora
				
		else:
			texto_completo = pieza_ganadora + " blanco mató a " + pieza_perdedora
			if pieza_ganadora == "Torre" or pieza_ganadora == "Reina":
				texto_completo = pieza_ganadora + " blanca mató a " + pieza_perdedora
		
	actualizar_log(texto_completo, 2)

func actualizar_log(mensaje: String, tipo: int = 5):    
	var color = _obtener_color_por_tipo(tipo)
	var icono = _obtener_icono_por_tipo(tipo)
	var linea_log = "[color=%s]%s %s[/color]\n" % [color, icono, mensaje]
	log_texto.text = linea_log + log_texto.text
	_limitar_lineas_log()

func _obtener_color_por_tipo(tipo: int) -> String:
	match tipo:
		0: return "#ffaa55"
		1: return "#55ff55"
		2: return "#ff5555"
		3: return "#ffff55"
		4: return "#55aaff"
		_: return "#ffffff"

func _obtener_icono_por_tipo(tipo: int) -> String:
	match tipo:
		0: return "⚠️"
		1: return "✅"
		2: return "⚔️"
		3: return "💰"
		4: return "🖥️"
		_: return "📝"

func _limitar_lineas_log():
	var lineas = log_texto.text.split("\n", false)
	if lineas.size() > max_mensajes:
		log_texto.text = "\n".join(lineas.slice(0, max_mensajes))

func limpiar_log():
	log_texto.text = ""
