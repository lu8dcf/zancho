extends Node2D

@onready var espera_en_pantalla: Timer =  $Espera
const DESTINO_MONEDERO = Vector2(850, 25)

func _ready() -> void:
	posicionar_en_centro_aleatorio()
	espera_en_pantalla.timeout.connect(animar_vuelo_moneda)

func posicionar_en_centro_aleatorio() -> void:
	Sonidos.sonar_sfx("gano_moneda")
	# 1. Obtener la posición central exacta de la pantalla de juego
	var centro_pantalla: Vector2 = get_viewport_rect().size / 2
	
	# 2. Generar un desvío aleatorio entre -100 y +100 para cada eje
	var desvio_x: float = randf_range(-15.0, 15.0)
	var desvio_y: float = randf_range(-15.0, 15.0)
	var vector_desvio := Vector2(desvio_x, desvio_y)
	
	# 3. Asignar la posición final al Area2D
	global_position = centro_pantalla + vector_desvio

func animar_vuelo_moneda() -> void:
	# 1. Aseguramos que arranque en el centro de la pantalla
	var centro_pantalla = get_viewport_rect().size / 2
	global_position = centro_pantalla
	
	# 2. Creamos una posición intermedia aleatoria para crear el efecto "arco" o explosión inicial
	# Esto hace que cada moneda tome un camino ligeramente diferente
	var desvio_inicial = Vector2(randf_range(-100, 100), randf_range(-100, 100))
	var posicion_intermedia = centro_pantalla + desvio_inicial
	
	# Variable para calcular un tiempo de viaje ligeramente único por moneda (entre 0.6 y 0.9 segundos)
	var duracion_viaje: float = randf_range(0.6, 0.9)
	
	
	var tween = create_tween()
	tween.set_parallel(true)
	
	# --- ANIMACIÓN DE MOVIMIENTO (Trayectoria en curva) ---
	# Paso A: La moneda sale disparada hacia el punto intermedio aleatorio (0.2 segundos)
	tween.tween_property(self, "global_position", posicion_intermedia, 0.2)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
		
	# Paso B: Inmediatamente después, es atraída hacia el monedero (cadena consecutiva con .set_parallel(false) temporal)
	tween.set_parallel(false)
	tween.tween_property(self, "global_position", DESTINO_MONEDERO, duracion_viaje)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)
	
	# --- ANIMACIÓN DE ESCALA Y DESAPARICIÓN ---
	tween.set_parallel(true)
	# Hacemos que se encoja a cero justo antes de llegar al monedero
	# Le damos un retraso pequeño (0.2s) para que mantenga su tamaño durante el "salto" inicial
	tween.tween_property(self, "scale", Vector2.ZERO, duracion_viaje)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)\
		.set_delay(0.2)
		
	# 4. Auto-destrucción: Cuando todo el Tween termina, borramos la instancia de la memoria
	tween.set_parallel(false)
	tween.tween_callback(queue_free)
	#  Justo antes del queue_free ---- disparar una señal al HUD para que sume el número en el contador
