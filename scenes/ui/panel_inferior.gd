extends Panel


# panel inferior
@onready var contenedor_piezas =$ContenedorInventario
@onready var boton_vender_pieza = $BotonVender

# textos delos botones de las piezas
@onready var cant_peon: TextureButton = $CantPeon
@onready var cant_alfil: TextureButton = $CantAlfil
@onready var cant_caballo: TextureButton = $CantCaballo
@onready var cant_torre: TextureButton = $CantTorre
@onready var cant_reina: TextureButton = $CantReina

var botones_piezas: Array = []


# almacena la pieza qe se selecciono
var pieza_seleccionada_actual: Dictionary = {}
var valor = 0

func _ready():
	boton_vender_pieza.visible =false
	configurar_botones()
	economia.pieza_comprada.connect(_actualizar_inventario)
	economia.inventario_actualizado.connect(_actualizar_inventario)
	
	# Actualizar valores iniciales
	_actualizar_inventario(economia.inventario_actual)
	

func configurar_botones():
	# Agregar todos los botones al array
	botones_piezas = [cant_peon, cant_alfil, cant_caballo, cant_torre, cant_reina]
	
	# Asignar metadatos con el nombre de la pieza
	cant_peon.set_meta("nombre_pieza", "Peon")
	cant_peon.set_meta("tipo_pieza", 1)
	
	cant_alfil.set_meta("nombre_pieza", "Alfil")
	cant_alfil.set_meta("tipo_pieza", 2)
	
	cant_caballo.set_meta("nombre_pieza", "Caballo")
	cant_caballo.set_meta("tipo_pieza", 4)
	
	cant_torre.set_meta("nombre_pieza", "Torre")
	cant_torre.set_meta("tipo_pieza", 3)
	
	cant_reina.set_meta("nombre_pieza", "Reina")
	cant_reina.set_meta("tipo_pieza", 5)

func conectar_señales_botones():
	for boton in botones_piezas:
		boton.pressed.connect(_on_boton_pieza_presionado.bind(boton))

func _on_boton_pieza_presionado(boton: TextureButton):
	var nombre_pieza = boton.get_meta("nombre_pieza", "Desconocido")
	var tipo_pieza = boton.get_meta("tipo_pieza", 0)
	var texto_boton = boton.text if boton.text else ""
	
	print("Botón presionado: ", nombre_pieza)
	print("  - Texto: ", texto_boton)
	print("  - Tipo: ", tipo_pieza)
	
	# Buscar la pieza en el inventario
	var pieza_data = _buscar_pieza_en_inventario(nombre_pieza)
	if pieza_data.is_empty():
		print("Pieza no encontrada en inventario")
		return
	
	# Manejar la selección
	pieza_seleccionada_actual = pieza_data
	
	if Piezas.modo_colocacion:
		Piezas.cancelar_modo_colocacion()
	
	if pieza_data.get("cantidad", 0) > 0:
		Piezas.iniciar_modo_colocacion(tipo_pieza, nombre_pieza)
		
		# Mostrar botón vender
		boton_vender_pieza.visible = true
		valor = _obtener_valor_reventa(nombre_pieza)
		boton_vender_pieza.text = "VENDER " + nombre_pieza + "\n💰 +" + str(valor)

func _buscar_pieza_en_inventario(nombre_pieza: String) -> Dictionary:
	for pieza in economia.inventario_actual:
		if pieza.get("nombre", "") == nombre_pieza:
			return pieza
	return {}

func _actualizar_inventario(_pieza_nueva) -> void:
	actualizar_textos_botones()

func actualizar_textos_botones():
	# Actualizar el texto de cada botón según el inventario
	for boton in botones_piezas:
		var nombre_pieza = boton.get_meta("nombre_pieza", "")
		var pieza_data = _buscar_pieza_en_inventario(nombre_pieza)
		
		if not pieza_data.is_empty():
			var cantidad = pieza_data.get("cantidad", 0)
			var limite = economia.limite_piezas.get(nombre_pieza, 0)
			
			# Actualizar texto del botón
			boton.cambiar_texto(nombre_pieza + "\n" + str(cantidad) + "/" + str(limite))
			
			# Deshabilitar si no hay piezas
			boton.disabled = cantidad <= 0
			boton.modulate = Color(1, 1, 1, 1) if cantidad > 0 else Color(0.5, 0.5, 0.5, 1)
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
				boton_vender_pieza.visible = false
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
