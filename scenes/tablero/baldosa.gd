extends Node3D
class_name BaldosaBase

# Señales
signal baldosa_presionada(baldosa)
signal baldosa_resaltada(baldosa, estado)
signal baldosa_click_derecho(baldosa)

# Enumeración para el tipo de baldosa
enum TipoBaldosa {
	CLARA,
	OSCURA
}

# Variables exportadas para configurar en el editor
@export var tipo : TipoBaldosa = TipoBaldosa.CLARA
@export var modelo_glb_claro : PackedScene  # Modelo GLB para baldosa clara
@export var modelo_glb_oscuro : PackedScene  # Modelo GLB para baldosa oscura

# Variables públicas
var coordenadas_tablero : Vector2i = Vector2i(-1, -1)
var esta_ocupada : bool = false
var pieza_actual = null
var esta_resaltada : bool = false
var esta_seleccionada : bool = false

# Referencias a nodos hijos
@onready var contenedor_modelo : Node3D = $ContenedorModelo
@onready var area_interaccion : Area3D = $AreaInteraccion
@onready var cuerpo_estatico : StaticBody3D = $CuerpoEstatico
@onready var indicador_seleccion : Node3D = $IndicadorSeleccion
@onready var indicador_resaltado : Node3D = $IndicadorResaltado

# variable publica para el gestor de hover
var mouse_sobre_baltosa : bool = false

func _ready():
	configurar_colision()
	cargar_modelo_glb()
	conectar_señales()
	configurar_indicadores()

func configurar_colision():
	# Aseguramos que el StaticBody3D tenga su CollisionShape3D
	if cuerpo_estatico:
		var forma_colision = cuerpo_estatico.get_node_or_null("ColisionBaldosa")
		if not forma_colision:
			# Crear forma de colisión si no existe
			forma_colision = CollisionShape3D.new()
			forma_colision.name = "ColisionBaldosa"
			cuerpo_estatico.add_child(forma_colision)
			
			# Crear una forma de caja para la colisión
			var forma_caja = BoxShape3D.new()
			forma_caja.size = Vector3(1.0, 0.1, 1.0)  # Ajusta según tu modelo
			forma_colision.shape = forma_caja

func cargar_modelo_glb():
	if not contenedor_modelo:
		push_error("Falta el nodo ContenedorModelo")
		return
	
	# Limpiar modelos anteriores
	for hijo in contenedor_modelo.get_children():
		hijo.queue_free()
	
	# Seleccionar el modelo según el tipo
	var modelo_a_cargar = modelo_glb_claro if tipo == TipoBaldosa.CLARA else modelo_glb_oscuro
	
	if modelo_a_cargar:
		var instancia_modelo = modelo_a_cargar.instantiate()
		contenedor_modelo.add_child(instancia_modelo)
	else:
		push_error("No se ha asignado modelo GLB para baldosa tipo: ", tipo)

func conectar_señales():
	if area_interaccion:
		area_interaccion.mouse_entered.connect(_al_entrar_mouse)
		area_interaccion.mouse_exited.connect(_al_salir_mouse)
		area_interaccion.input_event.connect(_al_evento_input)

func configurar_indicadores():
	if indicador_seleccion:
		indicador_seleccion.visible = false
	if indicador_resaltado:
		indicador_resaltado.visible = false

func establecer_coordenadas(columna: int, fila: int):
	coordenadas_tablero = Vector2i(columna, fila)
	position = Vector3(columna, 0, fila)

func obtener_coordenadas() -> Vector2i:
	return coordenadas_tablero

func resaltar(estado: bool):
	esta_resaltada = estado
	if indicador_resaltado:
		indicador_resaltado.visible = estado
	baldosa_resaltada.emit(self, estado)

func seleccionar(estado: bool):
	esta_seleccionada = estado
	if indicador_seleccion:
		indicador_seleccion.visible = estado

func _al_entrar_mouse():
	if not esta_ocupada:
		resaltar(true)

func _al_salir_mouse():
	if not esta_ocupada:
		resaltar(false)

func _al_evento_input(camara, evento, posicion_click, normal_click, indice_forma):
	if evento is InputEventMouseButton:
		if evento.button_index == MOUSE_BUTTON_LEFT and evento.pressed:
			baldosa_presionada.emit(self)
		elif evento.button_index == MOUSE_BUTTON_RIGHT and evento.pressed:
			baldosa_click_derecho.emit(self)

# Método para obtener el punto de colocación de piezas (útil para posicionar piezas sobre la baldosa)
func obtener_punto_colocacion() -> Vector3:
	return position + Vector3(0, 0.2, 0)  # Altura ajustable según el modelo

# Método para verificar si una posición 3D está dentro de esta baldosa
func contiene_punto(punto: Vector3) -> bool:
	var local = to_local(punto)
	var margen = 0.5  # Mitad del tamaño de la baldosa
	return abs(local.x) <= margen and abs(local.z) <= margen
