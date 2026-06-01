extends Node3D
class_name GestorTablero

# Variables exportadas
@export var escena_baldosa : PackedScene
@export var modelo_glb_claro : PackedScene
@export var modelo_glb_oscuro : PackedScene
@export var tamano_tablero : Vector2i = globalJuego.tamano_tablero #(30:16)
@export var espaciado_baldosas : float = globalJuego.espaciado_baldosas
@export var altura_piezas : float = 0.2

# Variables privadas
var baldosas : Dictionary = {}  # Diccionario con clave Vector2i -> BaldosaBase
var baldosa_seleccionada : BaldosaBase = null


func _ready():
	add_to_group("gestor_tablero")
	generar_tablero()	
	mostrar_oleada_actual(true) # se genera la oleada con el rey
	conectar_señales_baldosas()
	
	GlobalSignal.finalizaOleada.connect(mostrar_oleada_actual) # si es true quiere decir que gano, si es false se reiniciaa

func generar_tablero():
	# Limpiar tablero existente
	for hijo in get_children():
		if hijo is BaldosaBase:
			hijo.queue_free()
	baldosas.clear()
	
	# generar  tablero
	for fila in range(tamano_tablero.y):
		for columna in range(tamano_tablero.x):
			var baldosa = crear_baldosa(columna, fila)
			if baldosa:
				baldosas[Vector2i(columna, fila)] = baldosa

func crear_baldosa(columna: int, fila: int) -> BaldosaBase:
	if not escena_baldosa:
		return null
	
	var baldosa = escena_baldosa.instantiate() as BaldosaBase
	if not baldosa:
		return null
	
	# Determinar el tipo de baldosa (alternar colores como ajedrez)
	var es_clara = (columna + fila) % 2 == 0
	baldosa.tipo = BaldosaBase.TipoBaldosa.CLARA if es_clara else BaldosaBase.TipoBaldosa.OSCURA
	
	# Asignar modelos GLB
	baldosa.modelo_glb_claro = modelo_glb_claro
	baldosa.modelo_glb_oscuro = modelo_glb_oscuro
	
	# Establecer coordenadas y posición
	baldosa.establecer_coordenadas(columna, fila)
	baldosa.position = Vector3(columna * espaciado_baldosas, 0, fila * espaciado_baldosas)
	
	if not baldosa.mostrar_ataques.is_connected(_on_mostrar_ataques):
		baldosa.mostrar_ataques.connect(_on_mostrar_ataques)
	add_child(baldosa)
	return baldosa

func conectar_señales_baldosas():
	for baldosa in baldosas.values():
		if not baldosa.mostrar_ataques.is_connected(_on_mostrar_ataques):
			baldosa.mostrar_ataques.connect(_on_mostrar_ataques)

func _on_mostrar_ataques(coordenadas_base: Vector2i, ataques: Array, mostrar: bool):
	if mostrar:
		_resaltar_casillas_ataque(coordenadas_base, ataques)
	else:
		_limpiar_resaltado_ataque()

func _resaltar_casillas_ataque(posicion_base: Vector2i, ataques: Array):
	_limpiar_resaltado_ataque()  # Limpiar anteriores
	for ataque in ataques:
		var pos_x = posicion_base.x + ataque.x
		var pos_y = posicion_base.y + ataque.z
		
		# Verificar que la posición está dentro del tablero
		if pos_x >= 0 and pos_x < tamano_tablero.x and pos_y >= 0 and pos_y < tamano_tablero.y:
			var baldosa_objetivo = obtener_baldosa_en_coordenadas(Vector2i(pos_x, pos_y))
			if baldosa_objetivo:
				baldosa_objetivo.seleccionar(true)  # Usar el indicador existente o crear uno nuevo

# NUEVA FUNCIÓN: Limpiar el resaltado de ataques
func _limpiar_resaltado_ataque():
	for baldosa in baldosas.values():
		if not baldosa.esta_ocupada:  # Solo limpiar baldosas no ocupadas
			baldosa.seleccionar(false)
			
func obtener_baldosa_en_coordenadas(coordenadas: Vector2i) -> BaldosaBase:
	return baldosas.get(coordenadas, null)

func obtener_baldosa_en_posicion(columna: int, fila: int) -> BaldosaBase:
	return obtener_baldosa_en_coordenadas(Vector2i(columna, fila))

# revisar esta linea de codigo
func _en_baldosa_presionada(baldosa: BaldosaBase):	
	if baldosa_seleccionada:
		baldosa_seleccionada.seleccionar(false)
		return
	
	baldosa_seleccionada = baldosa

func limpiar_seleccion():
	if baldosa_seleccionada:
		baldosa_seleccionada.seleccionar(false)
		baldosa_seleccionada = null
									# vector(3,2) posicion de la baldosa

func obtener_punto_colocacion_pieza(coordenadas: Vector2i) -> Vector3:
	var baldosa = obtener_baldosa_en_coordenadas(coordenadas)
	if baldosa:
		return baldosa.obtener_punto_colocacion()
	return Vector3.ZERO

func mostrar_oleada_actual(gano):
	GlobalSignal.emit_signal("aceleraMarcaPaso",2)
	GlobalSignal.emit_signal("controlMarcaPaso",true)
	if gano:
		await get_tree().create_timer(2.0).timeout
		GlobalSignal.emit_signal("crearPieza",Vector2i(1,14),0,true)
		economia.obtener_inventario_dinero_despues_oleada(true)

	else:
		# se crea otro rey aunque haya perdido
		GlobalSignal.emit_signal("crearPieza",Vector2i(1,14),0,true)
		economia.obtener_inventario_dinero_despues_oleada(false)
		
	await get_tree().process_frame
	
	var baldosa_rey = obtener_baldosa_en_coordenadas(Vector2i(1, 14))
	if baldosa_rey:
		baldosa_rey.esta_ocupada = true
		baldosa_rey.tipo_pieza_actual = 0  # 0 = Rey según tu array
		
