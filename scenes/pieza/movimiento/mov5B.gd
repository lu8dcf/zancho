extends Node
class_name ReinaB

# Referencia a la pieza base (el RigidBody3D que contiene este componente)
var pieza: PiezaBase

#baldosas vecinas
const DIRECCIONES = [ #Son las 8 direccions qque tiene a su alrededor
	Vector3i(1,0,0), Vector3i(-1,0,0),
	Vector3i(0,0,1), Vector3i(0,0,-1),
	Vector3i(1,0,1), Vector3i(-1,0,1),
	Vector3i(-1,0,-1), Vector3i(1,0,-1)
]

var fin = null
var tiene_objetivo := false
var en_movimiento := false

# desplazamiento Reina
var direccion_actual : Vector3i = Vector3i(1, 0, -1) # hacia donde mira inicialmente
var direccion : Vector3i = Vector3i.ZERO

func _ready():
	# Obtener la referencia a la pieza base (el owner del componente)
	pieza = get_parent() as PiezaBase
	# Verificar que se obtuvo correctamente
	if not pieza:
		print ("El componente Reina debe ser hijo directo de una PiezaBase")
		return
	# Conectar señal después de que la pieza esté lista
	await pieza.ready
	GlobalSignal.connect("marcaPaso", puedoAvanzar)

func _input(event):
	if event is InputEventMouseButton and event.pressed: #revisar esto para que solo ande
		if event.button_index == MOUSE_BUTTON_LEFT: #solo ocn el mouse izquierdo
			fin = obtengo_posicion_baldosa()   #con click izqui	rdo
			#if(fin == null):
				#fin = calculoPosActual()
			tiene_objetivo = true #tiene un punto donde ir, es fin
			

func puedoAvanzar(): #funcion que se sincroniza con el marcapaso, veo si tengo objetivo
	if (tiene_objetivo and fin != null):
		avanzoEnTiempo(fin)

func avanzoEnTiempo(fin : Vector3i):
	if en_movimiento: 
		return
	var posActual = calculoPosActual()
	if(posActual != fin): #si aun no llegue al objetivo, repito
		analizar_siguientePaso(posActual, fin)

func calculoPosActual() -> Vector3i:
	var actual = Vector3i(
	round(owner.global_position.x / GlobalJuego.espaciado_baldosas),
	0,
	round(owner.global_position.z / GlobalJuego.espaciado_baldosas))
	return actual

func analizar_siguientePaso(inicio: Vector3i, fin: Vector3i): #
	var actual = inicio #posicion atual
	var mejor_vecino = null
	var mejor_dist = INF
	for dir in DIRECCIONES: # de todas las direcciones
		var vecino = actual + dir
		if  not es_valido(vecino):
			continue
		var dist = (fin - vecino).length_squared()
		if dist < mejor_dist: #comparo
			mejor_dist = dist
			mejor_vecino = vecino #obtengo la que mas me acerca al clickeado
	if mejor_vecino != null:
		var dir = mejor_vecino - actual
		print ("Dir: ", dir)
		if dir != direccion_actual:
			direccion_actual = dir
			girar(dir)
		moverPaso(mejor_vecino) #avanzo a la mejor posicion
	else:
		moverPaso(calculoPosActual())

func moverPaso(destino:Vector3i): #desplazo la pieza a la sieguiente
	if (en_movimiento):
		return
	var avanzo = Vector3(
		destino.x * GlobalJuego.espaciado_baldosas,
		owner.global_position.y,
		destino.z * GlobalJuego.espaciado_baldosas
	)
	en_movimiento = true

	var tween = create_tween() #animacion y muevo
	tween.tween_property(owner, "global_position", avanzo , 1) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN_OUT)
	
	tween.finished.connect(func():
		en_movimiento = false
	)

func es_valido(pos: Vector3i) -> bool: #me aseguro que se pueda usar la baldosa
	var pos2d = Vector2i(pos.x, pos.z)
	if globalJuego.verifica_extremos(pos2d)==false:
		return false
	if globalJuego.verifica_obstaculos(pos2d)==false:
		return false
	#if globalJuego.verifica_piezas(pos2d)==false:
	#	return false
	return true

func obtengo_posicion_baldosa() -> Vector3:
	var max_distancia := 1000.0
	var camera = get_viewport().get_camera_3d() #obtengo la camara
	var mouse_pos = get_viewport().get_mouse_position() # y la posición del mouse

	var ray_origin = camera.project_ray_origin(mouse_pos) #origen del rayo, camara
	var ray_direction = camera.project_ray_normal(mouse_pos) #fin del rayo, posicion del click
	
	var space_state = camera.get_world_3d().direct_space_state #obtengo las fisicas para usar un raycast
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin,
	ray_origin + ray_direction * max_distancia) #creo el rayo
	
	var result = space_state.intersect_ray(query)
	if result:
		var baldosaReal = Vector3( #obtengo la posicion real de la baldosa
		result.position.x / GlobalJuego.espaciado_baldosas,
		owner.global_position.y,
		result.position.z / GlobalJuego.espaciado_baldosas)
		return round(baldosaReal)
	return self.global_position #mantengo posicion si no selecciono baldosa


func girar(direccion: Vector3i): #giro la reina en base a la direccion del objetivo
	match round(direccion):
		Vector3i(0,0,-1): #awrriba
			owner.giro(-90) #perfecto
		Vector3i(1, 0, -1): #arriba derecha
			owner.giro(225) 
		Vector3i(1, 0, 0): # derecha
			owner.giro(180) #reviar para que no de toda la vuelta
		Vector3i(1, 0, 1): # abajo-derecha
			owner.giro(135) #reviar para que no de toda la vuelta
		Vector3i(0, 0, 1): # abajo
			owner.giro(90) #perfecto
		Vector3i(-1, 0, 1): # abajo-izquierda
			owner.giro(45) #perfecto
		Vector3i(-1, 0, 0): # izquierda
			owner.giro(0) #perfecto
		Vector3i(-1, 0, -1): # arriba-izquierda
			owner.giro(-45) #perfecto
#angulos cada 45 grados -abajo = 45 - derecha 90
