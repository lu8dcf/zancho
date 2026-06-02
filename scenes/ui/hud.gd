extends CanvasLayer

#panel inferior
@onready var panel_inferior: Panel = $PanelInferior
@onready var imagen_back_inferior: TextureRect = $imagenBackInferior
@onready var panel_rey: Panel = $imagenBackInferior/PanelRey

# contenedor de log
@onready var log: RichTextLabel = $ContenedorLog/Log

var max_mensajes :int = 50
#panel superior
@onready var panel_superior: Panel = $PanelSuperior

# texto debug
@onready var label_debug_temporal: Label = $Label_debug_temporal

# pantalla temporal de ganar
@onready var imagen_oleada: TextureRect = $GanoOleada
var gano = load("res://assets/ui/gano_oleada.png")
var perdio = load("res://assets/ui/perdiste.jpg")

var tween : Tween

func _ready():
	mostrar_todos_paneles()
	imagen_oleada.modulate.a = 0  
	imagen_oleada.visible = false
	label_debug_temporal.text = "Debug: " + str(globalJuego.debug) # true y # false
	log.bbcode_enabled = true
	log.scroll_active = false
	# ocultar la tienda
	GlobalSignal.finalizaOleada.connect(mostrar_imagen)
	GlobalSignal.mensaje_oleada.connect(mensaje_oleada_log)
	GlobalSignal.mensaje_tienda.connect(mensaje_tienda_log)
	Piezas.pieza_colocada.connect(mensaje_colocacion_log)

func mostrar_todos_paneles():
	panel_inferior.visible = true
	panel_superior.visible = true
	panel_rey.visible = true
	
func mostrar_imagen(ganar: int) -> void:
	globalJuego.empezo_oleada=false
	$PanelTienda._ocultar_tienda()
	if ganar:
		imagen_oleada.texture = gano
		mostras_desaparecer_imagen()
		
		globalJuego.siguiente_oleada() # cambia la oleada a la siguiete
	else:
		imagen_oleada.texture = perdio
		mostras_desaparecer_imagen()
		globalJuego.perder_fe(5)
		
func mostras_desaparecer_imagen():
	# Matar tween anterior si existe
		if tween and tween.is_valid():
			tween.kill()
		
		tween = create_tween()
		imagen_oleada.visible = true
		imagen_oleada.modulate.a = 0
		
		# Fade in: aparece en 0.5 segundos
		tween.tween_property(imagen_oleada, "modulate:a", 1.0, 0.5)
		# Espera 2 segundos visible
		tween.tween_interval(4.0)
		# Fade out: desaparece en 0.5 segundos
		tween.tween_property(imagen_oleada, "modulate:a", 0.0, 0.5)
		# Al terminar, ocultar completamente
		tween.tween_callback(_ocultar_imagen)


func _ocultar_imagen() -> void:
	imagen_oleada.visible = false

# signal mensaje_oleada(empieza:bool,gano:bool) 
func mensaje_oleada_log(empieza:bool, gano = null):
	var texto_completo = ""
	var tipo = null
	if empieza:
		texto_completo += "Empieza la Oleada "+ str(GlobalJuego.oleada_actual)
		tipo = 2
	else:
		texto_completo += "Terminó la Oleada "+ str(GlobalJuego.oleada_actual)
		if gano:
			tipo = 1
			texto_completo += "¡Ganaste!"
		else:
			tipo = 0
			texto_completo += "¡Perdiste! Tus piezas pierden Fé "
	actualizar_log(texto_completo, tipo)
			
			
func mensaje_tienda_log(compra:bool,nombre_pieza:String):
	var texto_completo = ""
	var tipo = 3
	if compra:
		texto_completo += "Compraste "+ nombre_pieza
		
	else:
		texto_completo += "Vendiste "+ nombre_pieza
	actualizar_log(texto_completo,tipo)

#pieza_colocada(tipo:int, posicion:Vector2i)
func mensaje_colocacion_log(tipo_pieza:int,posicion:Vector2i):
	var texto_completo = ""
	var tipo = 4
	var nombre_pieza = economia.obtener_nombre_pieza(tipo_pieza)
	texto_completo += "Colocaste la pieza "+ nombre_pieza + " en la ubicación: "+ str(posicion)
	actualizar_log(texto_completo,tipo)

func mensaje_ataques():
	pass

func actualizar_log(mensaje: String, tipo: int = 5):	
	# Formatear según tipo
	var color = _obtener_color_por_tipo(tipo)
	var icono = _obtener_icono_por_tipo(tipo)
	
	# Crear línea de log
	var linea_log = "[color=%s]%s %s[/color]\n" % [color, icono, mensaje]
	
	log.text = linea_log + log.text  # Los mensajes nuevos arriba
	
	_limitar_lineas_log()

func _obtener_color_por_tipo(tipo: int) -> String:
	match tipo:
		0:
			return "#ffaa55"  # Naranja / advertencia
		1:
			return "#55ff55"  # Verde / exito
		2:
			return "#ff5555"  # Rojo / perder Combate
		3:
			return "#ffff55"  # Amarillo / economia
		4:
			return "#55aaff"  # Azul / sistma
		_:
			return "#ffffff"  # Blanco (info normal)

func _obtener_icono_por_tipo(tipo: int) -> String:
	match tipo:
		0:
			return "⚠️"
		1:
			return "✅"
		2:
			return "⚔️"
		3:
			return "💰"
		4:
			return "🖥️"
		_:
			return "📝"

func _limitar_lineas_log():
	var lineas = log.text.split("\n", false)
	if lineas.size() > max_mensajes:
		log.text = "\n".join(lineas.slice(0, max_mensajes))

# Función para limpiar el log
func limpiar_log():
	log.text = ""
