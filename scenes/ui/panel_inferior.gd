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
	
	#conectar señaes de economia
	economia.pieza_comprada.connect(_actualizar_inventario)
	economia.pieza_vendida.connect(_actualizar_inventario)
	economia.inventario_actualizado.connect(_actualizar_inventario)
	if not Piezas.pieza_colocada_inventario.is_connected(_on_pieza_colocada_desde_inventario):
		Piezas.pieza_colocada_inventario.connect(_on_pieza_colocada_desde_inventario)
		
	_actualizar_inventario(null)
	#GlobalSignal.finalizaOleada.connect(esconder_botones)
	#GlobalSignal.comienzoOleada.connect(esconder_botones)
	
	if(GlobalJuego.tutorial):
		GlobalSignal.connect("parpadeoPiezas",parpadeaPiezaComprada)

func parpadeaPiezaComprada(): #tutorial
	var tween = create_tween()
	for i in 2:
		tween.tween_property(self, "modulate", Color(1.5, 1.5, 0.0, 0.973), 0.3)
		tween.tween_property(self, "modulate", Color.WHITE, 0.2)


func configurar_botones():
	# agregar todos los botones al array
	botones_piezas = [boton_peon, boton_alfil, boton_caballo, boton_torre, boton_reina]
	cant_piezas = [cant_peon, cant_alfil, cant_caballo, cant_torre, cant_reina]
	
	var mapeo_piezas = {
		"Peon": 1,
		"Alfil": 2,
		"Torre": 3,
		"Caballo": 4,
		"Reina": 5
	}
	#asignar metadatos
	for boton in botones_piezas:
		var nombre_pieza = _obtener_nombre_desde_boton(boton)
		if nombre_pieza in mapeo_piezas:
			boton.set_meta("nombre_pieza", nombre_pieza)
			boton.set_meta("tipo_pieza", mapeo_piezas[nombre_pieza])
	
	for boton in cant_piezas:
		var nombre_pieza = _obtener_nombre_desde_boton(boton)
		if nombre_pieza in mapeo_piezas:
			boton.set_meta("nombre_pieza", nombre_pieza)
			boton.set_meta("tipo_pieza", mapeo_piezas[nombre_pieza])

func _obtener_nombre_desde_boton(boton: TextureButton) -> String:
	var nombre_nodo = boton.name	
	# mapeo de nombres de nodos a nombres de piezas
	var mapeo_nodos = {
		"boton_peon": "Peon",
		"BotonPeon": "Peon",
		"cant_peon": "Peon",
		"CantPeon": "Peon",
		"boton_alfil": "Alfil",
		"BotonAlfil": "Alfil",
		"cant_alfil": "Alfil",
		"CantAlfil": "Alfil",
		"boton_torre": "Torre",
		"BotonTorre": "Torre",
		"cant_torre": "Torre",
		"CantTorre": "Torre",
		"boton_caballo": "Caballo",
		"BotonCaballo": "Caballo",
		"cant_caballo": "Caballo",
		"CantCaballo": "Caballo",
		"boton_reina": "Reina",
		"BotonReina": "Reina",
		"cant_reina": "Reina",
		"CantReina": "Reina"
	}
	#obtener el nombre de la pieza de ese nodo
	return mapeo_nodos.get(nombre_nodo, "")

func conectar_señales_botones():
	for boton in botones_piezas:
		boton.pressed.connect(_on_boton_pieza_presionado.bind(boton))

func _on_boton_pieza_presionado(boton: TextureButton):
	var nombre_pieza = boton.get_meta("nombre_pieza", "")
	var tipo_pieza = boton.get_meta("tipo_pieza", 0)
	
	# verificar si hay piezas en el inventario
	var cantidad = economia.inventario_actual.get(nombre_pieza, 0)
	if cantidad <= 0:
		print("No hay ", nombre_pieza, " disponibles")
		return
	
	pieza_seleccionada_actual = {
		"nombre": nombre_pieza,
		"tipo": tipo_pieza,
		"cantidad": cantidad,
		"precio": economia.datos_piezas.get(nombre_pieza, {}).get("precio", 0)
	}
	# el modo colocacion es cuando se hace click en la pieza del inventario y se intenta colocar,
	if Piezas.modo_colocacion:
		Piezas.cancelar_modo_colocacion()

	
	
	Piezas.iniciar_modo_colocacion(tipo_pieza, nombre_pieza)



func _on_pieza_colocada_desde_inventario(_nombre_pieza: String):	
	actualizar_textos_botones()
		
func _obtener_tipo_pieza(nombre_pieza: String) -> int:
	var tipos = {
		"Peon": 1,
		"Alfil": 2,
		"Torre": 3,
		"Caballo": 4,
		"Reina": 5
	}
	return tipos.get(nombre_pieza, 0)


func _actualizar_inventario(_pieza_nueva = null) -> void:
	actualizar_textos_botones()


func actualizar_textos_botones(): # se actualizan todos los botones, cada vez que se compra, se vende, se coloca
	for boton in cant_piezas:
		var nombre_pieza = boton.get_meta("nombre_pieza", "")
		if nombre_pieza.is_empty():
			continue
		
		# necesitamos los datos directamente del diccionario de economía
		var cantidad = economia.inventario_actual.get(nombre_pieza, 0)
		var limite = economia.datos_piezas.get(nombre_pieza, {}).get("limite", 0)
		
		boton.cambiar_texto(nombre_pieza + " " + str(cantidad) + "/" + str(limite))
		
		# deshabilitar si no hay piezas
		boton.disabled = cantidad <= 0
		boton.modulate = Color(1, 1, 1, 1) if cantidad > 0 else Color(0.5, 0.5, 0.5, 1)
	
	for boton in botones_piezas:
		var nombre_pieza = boton.get_meta("nombre_pieza", "")
		if nombre_pieza.is_empty():
			continue
		
		var cantidad = economia.inventario_actual.get(nombre_pieza, 0)
		boton.disabled = cantidad <= 0
		boton.modulate = Color(1, 1, 1, 1) if cantidad > 0 else Color(0.5, 0.5, 0.5, 1)
		

func _input(event):
	if Piezas.modo_colocacion:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
				Piezas.cancelar_modo_colocacion()
				get_viewport().set_input_as_handled()
			elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				pass


func _on_boton_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main.tscn")
