extends Panel


# panel inferior
@onready var contenedor_piezas =$ContenedorInventario
@onready var boton_vender_pieza = $BotonVender


# almacena la pieza qe se selecciono
var pieza_seleccionada_actual: Dictionary = {}
var valor = 0

func _ready():
	boton_vender_pieza.visible =false
	
	espaciado()
	_crear_botones_piezas_inventario()
	economia.pieza_comprada.connect(_actualizar_inventario)
	
	
	# Actualizar valores iniciales
	_actualizar_inventario(economia.inventario_actual)
	

func _actualizar_inventario(_pieza_nueva) -> void:
	_crear_botones_piezas_inventario()
# Funcion de botones

func espaciado():
	# Configurar espaciado para tienda
	if contenedor_piezas and contenedor_piezas is GridContainer:
		# Espaciado horizontal y vertical entre botones
		contenedor_piezas.add_theme_constant_override("h_separation", 40)
		contenedor_piezas.add_theme_constant_override("v_separation", 15)


func _crear_botones_piezas_inventario() -> void:
	for hijo in contenedor_piezas.get_children():
		hijo.queue_free()
		
	for pieza in economia.inventario_actual:
		# Crear contenedor vertical para botón + label
		var contenedor_boton = VBoxContainer.new()
		contenedor_boton.alignment = BoxContainer.ALIGNMENT_CENTER
		
		# Crear botón
		var boton = Button.new()
		boton.text = pieza["nombre"]
		boton.custom_minimum_size = Vector2(100, 50)
		boton.set_meta("nombre", pieza["nombre"])
		
		# Crear label de cantidad
		var texto_cant = Label.new()
		texto_cant.text = str(pieza["cantidad"]) + "/" + str( economia.limite_piezas[pieza["nombre"]])
		texto_cant.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		texto_cant.add_theme_color_override("font_color", Color(1, 1, 0))
		texto_cant.add_theme_font_size_override("font_size", 14)
		
		# Deshabilitar botón si cantidad es 0
		if pieza["cantidad"] == 0:
			boton.disabled = true
			boton.modulate = Color(0.5, 0.5, 0.5, 1)
		else:
			boton.disabled = false
			boton.modulate = Color(1, 1, 1, 1)
		
		# Conectar señal
		boton.pressed.connect(_on_pieza_clicked.bind(pieza))
		
		# Añadir al contenedor
		contenedor_boton.add_child(boton)
		contenedor_boton.add_child(texto_cant)
		contenedor_piezas.add_child(contenedor_boton)

# ejemplo de inventario
#
#var inventario_actual = [
	#{"nombre": "Peon", "cantidad":8},
	#{"nombre": "Torre", "cantidad":2},
	#{"nombre": "Alfil",  "cantidad":2},
	#{"nombre": "Caballo", "cantidad":2},
	#{"nombre": "Reina", "cantidad":1}
#]

func _on_pieza_clicked(pieza: Dictionary) -> void:
	print("Panel: Pieza clickeada: ", pieza)
	boton_vender_pieza.visible = true
	
	pieza_seleccionada_actual = pieza
	if Piezas.modo_colocacion:
		Piezas.cancelar_modo_colocacion()
	
	if pieza["cantidad"]>0:
		var tipo_pieza = _obtener_tipo_por_nombre(pieza["nombre"])
		Piezas.iniciar_modo_colocacion(tipo_pieza,pieza["nombre"])
		boton_vender_pieza.text = "COLOCANDO " + pieza["nombre"] + "\nClick derecho para cancelar"
		
	#if boton_vender_pieza:
		_resaltar_boton(boton_vender_pieza, false)
		valor = _obtener_valor_reventa(pieza["nombre"])
		#boton_vender_pieza.text = "VENDER " + pieza["nombre"] + "\n💰 +" + str(valor)
	
	_resaltar_boton(boton_vender_pieza, true)
	
func _obtener_tipo_por_nombre(nombre: String) -> int:
	var tipos = {
		"Rey": 1,
		"Peon": 2,
		"Alfil": 3,
		"Torre": 4,
		"Caballo": 5,
		"Reina": 6
	}
	return tipos.get(nombre, 1)

func _resaltar_boton(boton_vender_pieza: Button, resaltar: bool):
	if resaltar:
		boton_vender_pieza.modulate = Color(1.5, 1.5, 1, 1)  # Más brillante
		boton_vender_pieza.add_theme_color_override("font_color", Color(1, 1, 0))
	else:
		boton_vender_pieza.modulate = Color(1, 1, 1, 1)
		boton_vender_pieza.add_theme_color_override("font_color", Color(1, 1, 1))

func _input(event):
	if Piezas.modo_colocacion:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
				Piezas.cancelar_modo_colocacion()
				boton_vender_pieza.visible = false
				get_viewport().set_input_as_handled()
			elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				# La colocación se maneja en GestorTablero
				pass


func _on_boton_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main.tscn")


func _on_boton_vender_pressed() -> void:
	if economia.has_method("vender_pieza"):
		economia.vender_pieza(pieza_seleccionada_actual,valor)
		boton_vender_pieza.visible=false
		
	
func _obtener_valor_reventa(nombre_pieza: String) -> int:
	# Buscar en el diccionario de valores de reventa	
	return economia.valor_reventa.get(nombre_pieza, 0)
