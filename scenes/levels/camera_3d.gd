extends Camera3D
class_name CamaraLibre3D

# Variables exportadas para ajustar en el editor
@export var velocidad_movimiento : float = 15.0
@export var velocidad_rotacion : float = 0.3
@export var sensibilidad_zoom : float = 2.0
@export var zoom_minimo : float = 1.0
@export var zoom_maximo : float = 40.0
@export var altura_minima : float = 2.0
@export var altura_maxima : float = 25.0
@export var suavizado_movimiento : float = 8.0
@export var suavizado_rotacion : float = 8.0
@export var distancia_minima_suelo :float = 1.0

# Variables de estado interno
var rotacion_actual : Vector2 = Vector2(-53, -46)  # Ángulo inicial de la cámara
var posicion_objetivo : Vector3
var zoom_actual : float = 12.0
var mouse_capturado : bool = false

# Referencias
@onready var centro_tablero : Vector3 = _calcular_centro_tablero()

func _ready():
	add_to_group("camara_principal")
		# Configurar posición inicial
	posicion_objetivo = centro_tablero
	
	# Aplicar rotación inicial
	rotation_degrees = Vector3(rotacion_actual.x, rotacion_actual.y, 0)
	
	# Capturar mouse para mejor control (opcional)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	print("Cámara libre inicializada. Usa WASD/Flechas para mover, Mouse para rotar, Rueda para zoom")


func _calcular_centro_tablero() -> Vector3:
	# Intentar encontrar el tablero automáticamente
	var gestor_tablero = get_tree().get_first_node_in_group("gestor_tablero")
	if gestor_tablero and gestor_tablero.has_method("obtener_centro_tablero"):
		return gestor_tablero.obtener_centro_tablero()
	
	# Si no se encuentra, usar posición por defecto para tablero 16x16
	return Vector3(-1.05, 20, 29.56)
 
func _input(evento):
	if Input.is_key_pressed(KEY_SPACE):
		print("centro: ", centro_tablero)
		var info_texto = "CÁMARA DEBUG\n"
		info_texto += "Posición: " + str(position.snapped(Vector3(0.01, 0.01, 0.01))) + "\n"
		info_texto += "Rotación: " + str(rotation_degrees.snapped(Vector3(0.1, 0.1, 0.1))) + "\n"
		info_texto += "Objetivo: " + str(posicion_objetivo.snapped(Vector3(0.01, 0.01, 0.01))) + "\n"
		info_texto += "Zoom: " + str(zoom_actual).pad_decimals(1) + "\n"
		print(info_texto)
		
	# Manejar zoom con rueda del mouse
	if evento is InputEventMouseButton:
		if evento.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_actual = max(zoom_actual - sensibilidad_zoom, zoom_minimo)
		elif evento.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_actual = min(zoom_actual + sensibilidad_zoom, zoom_maximo)
			
		#print("zoom: ", zoom_actual)
	
	# Capturar/liberar mouse con click derecho (opcional)
	if evento is InputEventMouseButton and evento.button_index == MOUSE_BUTTON_RIGHT:
		if evento.pressed:
			mouse_capturado = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			mouse_capturado = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Rotación con movimiento del mouse (cuando está capturado o siempre)
	if evento is InputEventMouseMotion:
		if mouse_capturado or Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
			rotacion_actual.y -= evento.relative.x * velocidad_rotacion
			rotacion_actual.x -= evento.relative.y * velocidad_rotacion
			
			# Limitar la rotación vertical para evitar vueltas completas
			rotacion_actual.x = clamp(rotacion_actual.x, -89, -5)

func _process(delta):
	# Manejar entrada de teclado para movimiento
	manejar_movimiento_teclado(delta)
	
	# Actualizar posición de la cámara suavemente
	actualizar_posicion_camara(delta)
	
	# Actualizar rotación de la cámara suavemente
	actualizar_rotacion_camara(delta)
	
func manejar_movimiento_teclado(delta):
	var direccion_movimiento = Vector3.ZERO
	
	# Movimiento horizontal (WASD y Flechas)
	# NOTA: En Godot, FORWARD es -Z, BACK es +Z, RIGHT es +X, LEFT es -X
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		direccion_movimiento.z -= 1.0  # Adelante
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		direccion_movimiento.z += 1.0  # Atrás
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		direccion_movimiento.x -= 1.0  # Izquierda
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		direccion_movimiento.x += 1.0  # Derecha
	
	# Velocidad aumentada con Shift
	var velocidad_actual = velocidad_movimiento
	if Input.is_key_pressed(KEY_SHIFT):
		velocidad_actual *= 2.5
	
	# Aplicar movimiento si hay dirección
	if direccion_movimiento.length() > 0:
		direccion_movimiento = direccion_movimiento.normalized()
		
		# CORRECCIÓN: Transformar la dirección según la rotación Y de la cámara
		var angulo_y = deg_to_rad(rotacion_actual.y)
		var direccion_rotada = Vector3(
			direccion_movimiento.x * cos(angulo_y) + direccion_movimiento.z * sin(angulo_y),
			0,
			-direccion_movimiento.x * sin(angulo_y) + direccion_movimiento.z * cos(angulo_y)
		)
		
		posicion_objetivo += direccion_rotada * velocidad_actual * delta

func actualizar_posicion_camara(delta):
	var angulo_h = deg_to_rad(rotacion_actual.y)
	var angulo_v = deg_to_rad(rotacion_actual.x)
	
	var direccion_camara = Vector3(
		cos(angulo_h) * cos(angulo_v),
		sin(angulo_v),
		sin(angulo_h) * cos(angulo_v)
	)
	
	# Posición en órbita alrededor del punto objetivo
	var offset = Vector3(
		cos(angulo_h) * cos(angulo_v),
		sin(angulo_v),
		sin(angulo_h) * cos(angulo_v)
	) * zoom_actual
	
	# Calcular posición deseada
	var posicion_deseada = posicion_objetivo - offset
	
	# Asegurar altura mínima sobre el suelo
	posicion_deseada.y = max(posicion_deseada.y, distancia_minima_suelo)
	
	# suavizar movimiento	
	position = position.lerp(posicion_deseada, suavizado_movimiento * delta)

func actualizar_rotacion_camara(delta):
	# Aplicar rotación suavizada
	var rotacion_objetivo = Vector3(rotacion_actual.x, rotacion_actual.y, 0)
	rotation_degrees = rotation_degrees.lerp(rotacion_objetivo, suavizado_rotacion * delta)
	
	# Asegurar que la cámara siempre mire al punto objetivo
	look_at(posicion_objetivo)

# Métodos públicos útiles
func enfocar_posicion(posicion: Vector3, suave: bool = true):
	posicion_objetivo = posicion
	if not suave:
		var angulo_h = deg_to_rad(rotacion_actual.y)
		var angulo_v = deg_to_rad(rotacion_actual.x)
		var offset = Vector3(
			cos(angulo_h) * cos(angulo_v),
			sin(angulo_v),
			sin(angulo_h) * cos(angulo_v)
		) * zoom_actual
		position = posicion_objetivo + offset

func enfocar_baldosa(baldosa: BaldosaBase):
	if baldosa:
		enfocar_posicion(baldosa.position)

func obtener_direccion_mouse_3d() -> Dictionary:
	"""Útil para seleccionar objetos con el mouse"""
	var espacio = get_world_3d().direct_space_state
	var origen = project_ray_origin(get_viewport().get_mouse_position())
	var fin = origen + project_ray_normal(get_viewport().get_mouse_position()) * 1000
	
	var consulta = PhysicsRayQueryParameters3D.create(origen, fin)
	var resultado = espacio.intersect_ray(consulta)
	
	return resultado
