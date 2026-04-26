extends Node
class_name ReinaB

var pasos=0 #cantidad dee pasos que dara para cambio de  secuencia 

# Referencia a la pieza base (el RigidBody3D que contiene este componente)
var pieza: PiezaBase
var proxima_posicion : Vector3

var target_position: Vector3
var objetivo: Vector3i
var clickeado : bool = false

#const DireccionesPrincipales = [
	#Vector3i(0,0,-1), Vector3i(1,0,0), Vector3i(0,0,1), Vector3i(-1,0,0)
#]

#baldosas vecinas
const DIRECCIONES = [
	Vector3i(1,0,0), Vector3i(-1,0,0),
	Vector3i(0,0,1), Vector3i(0,0,-1),
	Vector3i(1,0,1), Vector3i(-1,0,1),
	Vector3i(-1,0,-1), Vector3i(1,0,-1)
]
#const DIRECCIONESDiagonales = [
	#Vector3i(1,0,1), Vector3i(-1,0,1),
	#Vector3i(-1,0,-1), Vector3i(1,0,-1)
#]
var camino: Array = []

var fin = null
var tiene_objetivo := false
var en_movimiento := false

# desplazamiento Torre
var direccion= Vector3i(0,0,0)
var secuencia = [0,3,4,5,6,7,8,2,1,6,7,4]
var paso = 0

func obtenerPosMouse() -> Vector3:
	return get_mouse_world_position()
	
func obtener_posicion_actual() -> Vector3i:
	var pos = owner.global_position / GlobalJuego.espaciado_baldosas
	return Vector3i(round(pos.x), 0, round(pos.z))
	
func mouse_a_baldosa() -> Vector3i:
	var pos3d = get_mouse_world_position()
	var grid = pos3d / GlobalJuego.espaciado_baldosas
	return Vector3i(round(grid.x), 0, round(grid.z))

	
func get_mouse_world_position(max_distance := 1000.0) -> Vector3:
	var camera = get_viewport().get_camera_3d()
	var mouse_pos = get_viewport().get_mouse_position()

	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_direction = camera.project_ray_normal(mouse_pos)


	var space_state = camera.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
	ray_origin,
	ray_origin + ray_direction * max_distance
	)

	var result = space_state.intersect_ray(query)
	if result:
		return result.position
	return Vector3.ZERO

func _ready():
	# Obtener la referencia a la pieza base (el owner del componente)
	pieza = get_parent() as PiezaBase
	
	# Verificar que se obtuvo correctamente
	if not pieza:
		print ("El componente Peon debe ser hijo directo de una PiezaBase")
		return

	# Conectar señal después de que la pieza esté lista
	await pieza.ready
	#GlobalSignal.connect("marcaPaso",movimiento	)
	GlobalSignal.connect("marcaPaso", puedoAvanzar)
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		fin = mouse_a_baldosa()
		tiene_objetivo = true
#		var fin = mouse_a_baldosa()

func calcular_direccion_hacia_objetivo():
	var actual = Vector3i(
		round(owner.global_position.x / GlobalJuego.espaciado_baldosas),
		round(owner.global_position.y / GlobalJuego.espaciado_baldosas),
		round(owner.global_position.z / GlobalJuego.espaciado_baldosas)
	)

	var dir = objetivo - actual
	
	# Normalizar a pasos de -1, 0, 1
	dir.x = clamp(dir.x, -1, 1)
	dir.y = clamp(dir.z, -1, 1)

	direccion = Vector3i(dir.x, 0, dir.z)


func puedoAvanzar():
	if (tiene_objetivo and fin != null):
		avanzoEnTiempo(fin)
	
func avanzoEnTiempo(fin : Vector3i):
	if en_movimiento:
		return
	var posActual = calculoPosActual()
	if(posActual != fin):
		avanzar_paso(posActual, fin)

func calculoPosActual() -> Vector3i:
	var actual = Vector3i(
	round(owner.global_position.x / GlobalJuego.espaciado_baldosas),
	0,
	round(owner.global_position.z / GlobalJuego.espaciado_baldosas))
	return actual
func avanzar_paso(inicio: Vector3i, fin: Vector3i):
	var actual = inicio #posicion atual
	#while actual != fin: #minetras actual sea diferente al punto final
	var mejor_vecino = null
	var mejor_dist = INF
	for dir in DIRECCIONES:
		var vecino = actual + dir
		var dist = (fin - vecino).length_squared()
		if dist < mejor_dist:
			mejor_dist = dist
			mejor_vecino = vecino
	if mejor_vecino != null:
		moverUnPos(mejor_vecino, fin)

func moverUnPos(destino, fin :Vector3i):
	if (en_movimiento):
		return
	var avanzo = Vector3(
		destino.x * GlobalJuego.espaciado_baldosas,
		owner.global_position.y,
		destino.z * GlobalJuego.espaciado_baldosas
	)
	en_movimiento = true
	var tween = create_tween()
	tween.tween_property(owner, "global_position", avanzo , 1) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN_OUT)
	
	tween.finished.connect(func():
		en_movimiento = false
		#avanzoEnTiempo(fin)
	)
	
			#var dir2d = Vector2i(dir.x,dir.z)
			#if not GlobalJuego.verifica_obstaculos(dir2d):
			#	continue
			#if not es_valido(vecino):
				#continue
func es_valido(pos: Vector3i) -> bool:
	var pos2d = Vector2i(pos.x, pos.z)
	# dentro del tablero
	if not GlobalJuego.verifica_extremos(pos2d):
		return false
	# sin obstáculo
	if not GlobalJuego.verifica_obstaculos(pos2d):
		return false
	return true
	

	
func avanzar():
	if en_movimiento:
		return
	
	var siguiente = camino.pop_back()
	
	if siguiente != null :
		var destino = Vector3(
			siguiente.x * GlobalJuego.espaciado_baldosas,
			owner.global_position.y,
			siguiente.z * GlobalJuego.espaciado_baldosas
		)
		en_movimiento = true
		var tween = create_tween()
		tween.tween_property(owner, "global_position", destino , 1) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
		tween.finished.connect(func():
			en_movimiento = false
		)
	
func movimiento():
	if not clickeado:
		return

	calcular_direccion_hacia_objetivo()
	#girar_segun_direccion()

	var cambio = direccion * GlobalJuego.espaciado_baldosas

	var tween = create_tween()
	tween.tween_property(owner, "global_position", owner.global_position + cambio , 1)
	
#
#func movimiento():
	#if not clickeado:
		#return
	#calcular_direccion_hacia_objetivo()
	#var cambio = direccion * GlobalJuego.espaciado_baldosas
	##if owner.verificar_proximo_paso(cambio)==false:
		##saltar_paso() #bordear
		##return
	## proximo sitio a ocupar
	#var sitio3d = round(owner.global_position+cambio)/GlobalJuego.espaciado_baldosas # en 3d
	## convierto la proxima posicion en 2Di para 
	#var nuevo_sitio = Vector2i(sitio3d.x,sitio3d.z)  # en 2d
#
	#if globalJuego.verifica_extremos(nuevo_sitio)==false:
		#saltar_paso()
		#return
#
	#if globalJuego.verifica_obstaculos(nuevo_sitio)==false:
		#saltar_paso()
		#return
#
	##if globalJuego.verifica_piezas(nuevo_sitio)==false:
		##paso=0
		##return
#
	##owner.animacion_caminata("Bidle")
#
	#var tween = create_tween()
	#tween.tween_property(owner, "global_position", owner.global_position + cambio , 1) \
	#.set_trans(Tween.TRANS_SINE) \
	#.set_ease(Tween.EASE_IN_OUT)
	##paso = 3

	
func saltar_paso(): # volver a iniciar en otra posicion d esalto
	#paso +=1
	if paso >= len(secuencia):
		return

func obtener_mejor_direccion() -> Vector3i:
	var dirs = [
		direccion, # ideal
		Vector3i(direccion.x, 0, 0),
		Vector3i(0, 0, direccion.z),
		Vector3i(-direccion.x, 0, direccion.z),
		Vector3i(direccion.x, 0, -direccion.z)
	]

	for d in dirs:
		var cambio = d * GlobalJuego.espaciado_baldosas
		
		if owner.verificar_proximo_paso(cambio):
			return d
	
	return Vector3i.ZERO
func dar_paso(): 
	paso+=1
	#if paso==len(secuencia): paso=1
	paso = (paso + 1) % len(secuencia)
	cambio_estado(paso)

func girar(direccion: Vector3i):
	match direccion:
		Vector3i(1,0,0):
			owner.giro(90)
		Vector3i(-1,0,0):
			owner.giro(-90)
		Vector3i(0,0,1):
			owner.giro(180)
		Vector3i(0,0,-1):
			owner.giro(0)
		Vector3i(1,0,1):
			owner.giro(135)
		Vector3i(-1,0,1):
			owner.giro(-135)
		Vector3i(-1,0,-1):
			owner.giro(-45)
		Vector3i(1,0,-1):
			owner.giro(45)

# Estadod de la pieza
func cambio_estado(cambio):
	#cambio = cambio % len(secuencia)
	match secuencia[cambio]:
		0: # Quieto
			direccion = Vector3i(0,0,0)
			owner.giro(45)
			print("R0")
		1: # arriba 1
			direccion = Vector3i(0,0,-1)
			owner.giro(225)
			print("R1")
		2:# arriba 2
			direccion = Vector3i(0,0,1)
			owner.giro(225)
			print("R2")
		3: # derecha 1
			direccion = Vector3i(1,0,0)
			owner.giro(135)
			print("R3")
		4: # derecha 2
			direccion = Vector3i(-1,0,0)
			owner.giro(135)
			print("R4")
		5: # abajo 1
			direccion = Vector3i(1,0,1)
			owner.giro(45)
			print("R5")
		6:# adelante 2
			direccion = Vector3i(-1,0,1)
			owner.giro(45)
			print("R6")
		7: # izquierda 1
			direccion = Vector3i(-1,0,-1)
			owner.giro(-90)
			print("R7")
		8: # izquierda 2
			direccion = Vector3i(1,0,-1)
			owner.giro(-90)
			print("R8")

#conectar con funcion del mouse, y mover en esa direccion
#mo
	
