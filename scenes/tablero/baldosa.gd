extends Node3D
class_name BaldosaBase

# Señales
@warning_ignore("unused_signal")
signal baldosa_presionada(baldosa)
@warning_ignore("unused_signal")
signal baldosa_resaltada(baldosa, estado)
@warning_ignore("unused_signal")
signal baldosa_click_derecho(baldosa)
@warning_ignore("unused_signal")
signal mostrar_ataques(coordenadas_base, ataques, mostrar)

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
@onready var indicador_invalido: Node3D = $IndicadorInvalido
@onready var indicador_valido: Node3D = $IndicadorValido
@onready var indicador_seleccion: Node3D = $IndicadorSeleccion # al pasar el mouse por encima


# variable publica para el gestor de hover
var mouse_sobre_baltosa : bool = false

# variables para el sistema de colcocion
var es_valido_colocar:bool = false
var modo_colocacion_activo:bool = false

# para saber que tipo de pieza está sobre  la baldosa
var tipo_pieza_actual: int = -1

func _ready():
	
	configurar_colision()
	cargar_modelo_glb()
	conectar_señales()
	configurar_indicadores()
	
	#Piezas.modo_colocacion_inicia.connect(_on_modo_colocacion_iniciado)
	Piezas.modo_colocacion_cancelado.connect(_on_modo_colocacion_cancelado)
	Piezas.pieza_colocada.connect(_on_pieza_colocada)
	GlobalSignal.overPieza.connect(_mostrar_ataques_pieza) # se muestran los rangos de ataque de las piezas

func configurar_colision():
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
		#area_interaccion.input_event.connect(_al_evento_input)


func _on_modo_colocacion_iniciado(_tipo_pieza: int, _nombre: String):
	modo_colocacion_activo = true
	es_valido_colocar = true

func _on_modo_colocacion_cancelado():
	modo_colocacion_activo = false
	es_valido_colocar = false
	_ocultar_indicadores_colocacion()
	if not esta_ocupada:
		seleccionar(false)

func configurar_indicadores():
	if indicador_seleccion: # al pasar el mouse por encima
		indicador_seleccion.visible = false
	if indicador_invalido: # si es imposible colocar la pieza s
		indicador_invalido.visible = false
	if indicador_valido: # si es posible colocar la pieza
		indicador_valido.visible = false
	

func establecer_coordenadas(columna: int, fila: int):
	coordenadas_tablero = Vector2i(columna, fila)
	position = Vector3(columna, 0, fila)

func obtener_coordenadas() -> Vector2i:
	return coordenadas_tablero

func seleccionar(estado: bool):
	esta_seleccionada = estado
	if indicador_invalido:
		indicador_invalido.visible = estado

func _al_entrar_mouse():
	if modo_colocacion_activo:
		if es_valido_colocar:
			_mostrar_indicador_valido() # verde
		else:
			_mostrar_indicador_invalido() # rojo invalido
			
	else:
		if not esta_ocupada:
			seleccionar(true) # seleccion 

func _al_salir_mouse():
	if modo_colocacion_activo:
		_ocultar_indicadores_colocacion()
	else:
		if not esta_ocupada:
			seleccionar(false)
		
#signal overPieza(activo:bool, tipo: int,posicion: Vector3i)
 # si es activo: true tiene el mouse encima y si es false entocnes sale el mouse
# el tipo es el tipo de pieza
# y la posicion es donde esta la pieza

func _mostrar_ataques_pieza(mostrar:bool, tipo_pieza_actual:int, posicion:Vector3i ):
	var ataques_pieza = Piezas.obtener_ataques_pieza(tipo_pieza_actual)
	var posicion_transformada: Vector2i = Vector2i(posicion.x, posicion.z)
	if mostrar:
		if ataques_pieza != null:
			# Emitir señal para que el gestor del tablero muestre las casillas de ataque
			mostrar_ataques.emit(posicion_transformada, ataques_pieza, true)
	else:
		if ataques_pieza != null:
			mostrar_ataques.emit(posicion_transformada, ataques_pieza, false)

	
func _mostrar_indicador_valido():
	_ocultar_indicadores_colocacion()
	if indicador_valido:
		indicador_valido.visible = true
	

func _mostrar_indicador_invalido():
	_ocultar_indicadores_colocacion()
	if indicador_invalido:
		indicador_invalido.visible = true


func _ocultar_indicadores_colocacion():
	if indicador_valido:
		indicador_valido.visible = false
	if indicador_invalido:
		indicador_invalido.visible = false


func _on_pieza_colocada(_tipo:int, posicion:Vector2i):
	if posicion == coordenadas_tablero:
		esta_ocupada = true
		modo_colocacion_activo = false
		#tipo_pieza_actual = _tipo
		es_valido_colocar = false
		_ocultar_indicadores_colocacion()
		
#
#func _al_evento_input(camara, evento, posicion_click, normal_click, indice_forma):
	#print("Evento recibido en baldosa: ", coordenadas_tablero, " - Tipo: ", evento)
#
	#if evento is InputEventMouseButton:
		#if evento.button_index == MOUSE_BUTTON_LEFT and evento.pressed:
			#print("tratar de colocar: ", es_valido_colocar)
			#if modo_colocacion_activo:
				#if es_valido_colocar:
					#_intentar_colocar_pieza()
			#else:
				#baldosa_presionada.emit(self)
		#elif evento.button_index == MOUSE_BUTTON_RIGHT and evento.pressed:
			#if modo_colocacion_activo:
				#Piezas.cancelar_modo_colocacion()
			#else:
				#baldosa_click_derecho.emit(self)
			#
func _intentar_colocar_pieza():
	if Piezas.colocar_pieza_en_posicion(coordenadas_tablero):
		esta_ocupada = true
		
	else:
		print("Error al colocar pieza")

func obtener_punto_colocacion() -> Vector3:
	return position + Vector3(0, 0.2, 0)  # Altura ajustable según el modelo
