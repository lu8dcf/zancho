extends Panel


# textos delos botones de las piezas
@onready var cant_peon: TextureButton = $CantPeon

@onready var cant_alfil: TextureButton = $CantAlfil
@onready var cant_caballo: TextureButton = $CantCaballo
@onready var cant_torre: TextureButton = $CantTorre
@onready var cant_reina: TextureButton = $CantReina

# botones de piezas
@onready var boton_peon: TextureButton = $BotonPeon
@onready var boton_alfil: TextureButton = $BotonAlfil
@onready var boton_caballo: TextureButton = $BotonCaballo
@onready var boton_torre: TextureButton = $BotonTorre
@onready var boton_reina: TextureButton = $BotonReina


var botones_piezas: Array = []
var cant_piezas :Array = []

# almacena la pieza qe se selecciono
var pieza_seleccionada_actual: Dictionary = {}

func _ready():
	configurar_botones()
	conectar_señales_botones()
	
	economia.pieza_comprada.connect(_actualizar_inventario)
	economia.pieza_vendida.connect(_actualizar_inventario)
	
	economia.inventario_actualizado.connect(_actualizar_inventario)
	
	# Actualizar valores iniciales
	_actualizar_inventario(economia.inventario_actual)
	

func _process(_delta):
	if globalJuego.empezo_oleada:
		for boton in botones_piezas:
			boton.disabled = true
	else: 
		for boton in botones_piezas:
			boton.disabled = false
			
func configurar_botones():
	# Agregar todos los botones al array
	botones_piezas = [boton_peon, boton_alfil, boton_caballo, boton_torre, boton_reina]
	cant_piezas = [cant_peon, cant_alfil, cant_caballo, cant_torre, cant_reina]
	
	# Asignar metadatos con el nombre de la pieza
	boton_peon.set_meta("nombre_pieza", "Peon")
	boton_peon.set_meta("tipo_pieza", 1)
	
	boton_alfil.set_meta("nombre_pieza", "Alfil")
	boton_alfil.set_meta("tipo_pieza", 2)
	
	boton_caballo.set_meta("nombre_pieza", "Caballo")
	boton_caballo.set_meta("tipo_pieza", 4)
	
	boton_torre.set_meta("nombre_pieza", "Torre")
	boton_torre.set_meta("tipo_pieza", 3)
	
	boton_reina.set_meta("nombre_pieza", "Reina")
	boton_reina.set_meta("tipo_pieza", 5)
	
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
		

func _buscar_pieza_en_inventario(nombre_pieza: String) -> Dictionary:
	for pieza in economia.inventario_actual:
		if pieza.get("nombre", "") == nombre_pieza:
			return pieza
	return {}

func _actualizar_inventario(_pieza_nueva) -> void:
	actualizar_textos_botones()

func actualizar_textos_botones():
	# Actualizar el texto de cada botón según el inventario
	for boton in cant_piezas:
		var nombre_pieza = boton.get_meta("nombre_pieza", "")
		var pieza_data = _buscar_pieza_en_inventario(nombre_pieza)
		
		if not pieza_data.is_empty():
			var cantidad = pieza_data.get("cantidad", 0)
			var limite = economia.limite_piezas.get(nombre_pieza, 0)
			
			# Actualizar texto del botón
			boton.cambiar_texto(nombre_pieza +" "+ str(cantidad) + "/" + str(limite))
			
			# Deshabilitar si no hay piezas
			boton.disabled = cantidad <= 0
			boton.modulate = Color(1, 1, 1, 1) if cantidad > 0 else Color(0.5, 0.5, 0.5, 1)

func _input(event):
	#print("entra pero: ", Piezas.modo_colocacion)
	if Piezas.modo_colocacion:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
				Piezas.cancelar_modo_colocacion()
				get_viewport().set_input_as_handled()
			elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				pass


func _on_boton_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main.tscn")
