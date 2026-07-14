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

# panel tienda
@onready var panel_tienda: Panel = $PanelTienda

# escenas de victoria/derrota
var escena_victoria 
var escena_derrota 

# perder toda la fe
var escena_derrota_final

# insatancia pausa in game
@export var escena_pausa: PackedScene = preload("res://scenes/ui/components/pausa_in_game.tscn")



#tutorial
@onready var pantallaNegra = $blackOut
# -------------------------------------------------------------

var tween: Tween

var mouse_sobre_hud: bool = false

var pausa_container_actual: Control = null


func _ready():
	mostrar_todos_paneles()
	if GlobalJuego.debug == true:
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
	conectar_señales_mouse(self)
	
	
	escena_victoria = load("res://scenes/ui/components/ganaste_oleada.tscn")
	escena_derrota = load("res://scenes/ui/components/perdiste_oleada.tscn")
	escena_derrota_final = load("res://scenes/ui/derrota.tscn")

func _input(event):
	
	if event.is_action_pressed("ocultar_tienda"):
		panel_tienda._alternar_tienda()
	elif event.is_action_pressed("ocultar_todo"):
		if imagen_back_inferior.panel_visible:
			imagen_back_inferior._on_boton_esconder_inferior_pressed()
		if panel_superior.panel_visible:
			panel_superior._on_boton_esconder_superior_pressed()
		if panel_tienda.tienda_visible:
			panel_tienda._alternar_tienda()
	elif event.is_action_pressed("empezar_oleada"):
		panel_superior._on_empezar_oleada_pressed()
	elif event.is_action_pressed("pausa_oleada"):
		if  GlobalJuego.empezo_oleada:
			if GlobalJuego.juego_pausa:
				panel_superior._on_boton_play_pressed()
			else:
				panel_superior._on_boton_pausar_pressed()
				
	elif event.is_action_pressed("acelerar1"):
		panel_superior._on_boton_acelerar_1_pressed()
	elif event.is_action_pressed("acelerar2"):
		panel_superior._on_boton_acelerar_2_pressed()
	elif event.is_action_pressed("play_oleada"):
		panel_superior._on_boton_play_pressed()
		
		
func mostrar_pausa_ingame():
	panel_superior._on_boton_pausar_pressed()
	var instancia_pausa = escena_pausa.instantiate()
	add_child(instancia_pausa)

func mostrar_pausa_pantalla():

	if pausa_container_actual:
		return

	var pausa_container = Control.new()
	pausa_container.name = "PausaContainer"
	pausa_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pausa_container.set_anchors_preset(Control.PRESET_FULL_RECT)

	# ============================
	# MARCO ROJO
	# ============================

	var marco = Panel.new()
	marco.set_anchors_preset(Control.PRESET_FULL_RECT)
	marco.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var estilo_marco = StyleBoxFlat.new()
	estilo_marco.bg_color = Color(0, 0, 0, 0)

	estilo_marco.border_width_left = 6
	estilo_marco.border_width_right = 6
	estilo_marco.border_width_top = 6
	estilo_marco.border_width_bottom = 6

	estilo_marco.border_color = Color(0.9, 0.1, 0.1, 0.85)

	marco.add_theme_stylebox_override("panel", estilo_marco)

	pausa_container.add_child(marco)

	# ============================
	# OVERLAY OSCURO
	# ============================

	var overlay = ColorRect.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var shader_material = ShaderMaterial.new()
	var shader = Shader.new()

	shader.code = """
	shader_type canvas_item;

	void fragment() {
		vec2 center = UV - vec2(0.5);
		float dist = length(center) * 1.5;
		float vignette = smoothstep(0.8, 0.2, dist);

		COLOR = vec4(0.0, 0.0, 0.0, vignette * 0.15);
	}
	"""

	shader_material.shader = shader
	overlay.material = shader_material

	pausa_container.add_child(overlay)

	var panel_pausa = Panel.new()
	panel_pausa.size = Vector2(200, 50)

	panel_pausa.anchor_left = 1
	panel_pausa.anchor_right = 1

	panel_pausa.offset_left = -220
	panel_pausa.offset_right = -20

	panel_pausa.offset_top = 65
	panel_pausa.offset_bottom = 115

	panel_pausa.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var estilo = StyleBoxFlat.new()
	estilo.bg_color = Color(0.8, 0.1, 0.1, 0.9)

	estilo.set_corner_radius_all(8)

	estilo.border_width_left = 2
	estilo.border_width_right = 2
	estilo.border_width_top = 2
	estilo.border_width_bottom = 2

	estilo.border_color = Color(1, 0.3, 0.3, 0.8)

	panel_pausa.add_theme_stylebox_override("panel", estilo)

	pausa_container.add_child(panel_pausa)

	var texto = Label.new()

	texto.text = "PAUSA"

	texto.set_anchors_preset(Control.PRESET_FULL_RECT)

	texto.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	texto.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	texto.modulate = Color.WHITE

	texto.add_theme_font_size_override("font_size", 28)

	var font_path = "res://assets/fuentes/Enchanted Land DS D.otf"

	if ResourceLoader.exists(font_path):
		var fuente = load(font_path)
		texto.add_theme_font_override("font", fuente)

	panel_pausa.add_child(texto)

	add_child(pausa_container)


	marco.modulate.a = 0
	panel_pausa.modulate.a = 0

	var tween2 = create_tween()
	tween2.set_parallel(true)

	tween2.tween_property(marco, "modulate:a", 1.0, 0.3)
	tween2.tween_property(panel_pausa, "modulate:a", 1.0, 0.3)

	panel_pausa.scale = Vector2(0.8, 0.8)

	tween2.tween_property(
		panel_pausa,
		"scale",
		Vector2.ONE,
		0.3
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	pausa_container_actual = pausa_container
	
func ocultar_pausa_pantalla():
	if !pausa_container_actual:
		return

	var tween3 = create_tween()

	tween3.tween_property(
		pausa_container_actual,
		"modulate:a",
		0.0,
		0.25
	)

	tween3.tween_callback(
		pausa_container_actual.queue_free
	)

	pausa_container_actual = null

func conectar_señales_mouse(node: Node):
	if node is Control:
		if not node.is_connected("mouse_entered", _on_hud_mouse_entered):
			node.mouse_entered.connect(_on_hud_mouse_entered)
		if not node.is_connected("mouse_exited", _on_hud_mouse_exited):
			node.mouse_exited.connect(_on_hud_mouse_exited)
	
	for child in node.get_children():
		conectar_señales_mouse(child)

# avisar del hud a cursores que elmouse entro o salio
func _on_hud_mouse_entered():
	mouse_sobre_hud = true
	if has_node("/root/Cursores"):
		get_node("/root/Cursores").set_mouse_over_ui(true)
	else:
		print("ERROR No se encuentra cursoresss")

func _on_hud_mouse_exited():
	await get_tree().create_timer(0.05).timeout
	if not is_mouse_inside_hud():
		mouse_sobre_hud = false
		
		if has_node("/root/Cursores"):
			get_node("/root/Cursores").set_mouse_over_ui(false)

func is_mouse_inside_hud() -> bool:
	var mouse_pos = get_viewport().get_mouse_position()
	return _check_mouse_in_node(self, mouse_pos)

func _check_mouse_in_node(node: Node, mouse_pos: Vector2) -> bool:
	if node is Control and node.is_visible_in_tree():
		if node.get_global_rect().has_point(mouse_pos):
			return true
	
	for child in node.get_children():
		if _check_mouse_in_node(child, mouse_pos):
			return true
	
	return false
	
func mostrar_todos_paneles():
	panel_inferior.visible = true
	panel_superior.visible = true
	panel_rey.visible = true
	
func mostrar_imagen(ganar: bool) -> void:
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
			if (GlobalJuego.fe -5)<=0 and escena_derrota_final:
				var instancia_derrota = escena_derrota_final.instantiate()
				add_child(instancia_derrota)
				GlobalJuego.perder_fe(5)		
			
				
			else:
				if escena_derrota:
					var instancia_derrota = escena_derrota.instantiate()
					add_child(instancia_derrota)
				#mostras_desaparecer_imagen()
				GlobalJuego.perder_fe(5)

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
