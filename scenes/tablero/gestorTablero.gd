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

func generar_tablero():
	# Limpiar tablero existente
	for hijo in get_children():
		if hijo is BaldosaBase:
			hijo.queue_free()
	baldosas.clear()
	
	# Generar nuevo tablero
	for fila in range(tamano_tablero.y):
		for columna in range(tamano_tablero.x):
			var baldosa = crear_baldosa(columna, fila)
			if baldosa:
				baldosas[Vector2i(columna, fila)] = baldosa
				baldosa.baldosa_presionada.connect(_en_baldosa_presionada)
				baldosa.baldosa_click_derecho.connect(_en_baldosa_click_derecho)

func crear_baldosa(columna: int, fila: int) -> BaldosaBase:
	if not escena_baldosa:
		push_error("No se ha asignado la escena de baldosa")
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
	
	add_child(baldosa)
	return baldosa

func obtener_baldosa_en_coordenadas(coordenadas: Vector2i) -> BaldosaBase:
	return baldosas.get(coordenadas, null)

func obtener_baldosa_en_posicion(columna: int, fila: int) -> BaldosaBase:
	return obtener_baldosa_en_coordenadas(Vector2i(columna, fila))

func _en_baldosa_presionada(baldosa: BaldosaBase):
	print("Baldosa presionada en: ", baldosa.obtener_coordenadas())
	
	# Quitar selección de baldosa anterior
	if baldosa_seleccionada:
		baldosa_seleccionada.seleccionar(false)
	
	# Seleccionar nueva baldosa
	baldosa_seleccionada = baldosa
	baldosa.seleccionar(true)

func _en_baldosa_click_derecho(baldosa: BaldosaBase):
	print("Click derecho en baldosa: ", baldosa.obtener_coordenadas())

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
