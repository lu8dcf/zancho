extends Node
class_name CaballoN

var pasos = 0
var pieza: PiezaBase
var proxima_posicion: Vector3
var esValida = false

# Movimiento en L
var direccion = Vector3i(0, 0, 0)
var secuencia = []
var paso = 0

# Variables para el salto
var altura_salto: float = 5.0      # Altura máxima del salto
var duracion_salto: float = 1.0     # Duración total del salto
var posicion_inicial: Vector3
var posicion_final: Vector3
var tween_actual: Tween
var esta_saltando: bool = false

func _ready():
	pieza = get_parent() as PiezaBase
	
	if not pieza:
		print("Error: El componente CaballoN debe ser hijo directo de una PiezaBase")
		return
	await pieza.ready
	await get_tree().create_timer(1).timeout
	var posicionActual = calculoPosActual()
	#var limite = globalJuego.tamano_tablero.x - 1 #seria una general
	#depende del lado que este del tablero, cambia la secuencia
	if(posicionActual.x+ posicionActual.z<15):
		secuencia= [5,6,3,4,1,2,7,8]
	elif(posicionActual.x + posicionActual.z>15):
		secuencia = [6,5,7,3,2,1,8,4]
	else:
		#diagonal
		secuencia = [0,6,5]
		
	GlobalSignal.connect("marcaPaso",movimiento	)

func calculoPosActual() -> Vector3i:
	var actual = Vector3i(
	round(pieza.global_position.x / GlobalJuego.espaciado_baldosas),
	0,
	round(pieza.global_position.z / GlobalJuego.espaciado_baldosas))
	return actual



func movimiento():
	for i in range(secuencia.size()): #es un sistema de prioridad
		cambio_estado(secuencia[i]) #siempre muevea delante, si no, una casilla, si no a la derecha y asi
		var cambio = direccion * GlobalJuego.espaciado_baldosas # vector de cambio de la pieza
		if (owner.verificar_proximo_paso(cambio)):
			realizar_salto_parabolico(cambio)
			return
	cambio_estado(0)
	
	#
	#
	#
	#cambio_estado(paso)
	#var cambio = direccion * GlobalJuego.espaciado_baldosas
	#if owner.verificar_proximo_paso(cambio):
		#realizar_salto_parabolico(cambio)
		#dar_paso()
	#else:
		#buscar_siguiente_valido()

func dar_paso():
	paso+=1
	if paso==len(secuencia): paso=1
	cambio_estado(paso)
	
func saltar_paso(): # volver a iniciar en otra posicion d esalto
	buscar_siguiente_valido()  	
	
func buscar_siguiente_valido():
	for offset in range(1, len(secuencia) + 1):

		var indice = (paso + offset) % len(secuencia)

		cambio_estado(indice)

		var cambio = direccion * GlobalJuego.espaciado_baldosas
		var valido = owner.verificar_proximo_paso(cambio)
		if owner.verificar_proximo_paso(cambio):

			paso = indice

			realizar_salto_parabolico(cambio)

			dar_paso()

			return

	print("No hay movimientos válidos")
	

	
#func movimiento():
	#if esta_saltando:
		#print("El caballo ya está saltando, esperando...")
		#return
	#esValida = false
	## Calcular paso actual
	#paso += 1
	#if paso == len(secuencia):
		#paso = 1
	#cambio_estado(paso)
	#
	## Verificar si el movimiento en L es válido
	#var cambio = direccion * GlobalJuego.espaciado_baldosas
	#
	#if owner.verificar_proximo_paso(cambio):
		#esValida = true
		#realizar_salto_parabolico(cambio)
	#else:
		#saltar_pasos()

	
func realizar_salto_parabolico(cambio: Vector3):
	posicion_inicial = owner.global_position
	posicion_final = owner.global_position + cambio
	
	esta_saltando = true
	
	# Crear tween para la animación
	if tween_actual and tween_actual.is_valid():
		tween_actual.kill()
	
	tween_actual = create_tween()
	tween_actual.set_parallel(true)  # Animaciones en paralelo
	
	# 1. Movimiento horizontal lineal
	tween_actual.tween_method(actualizar_posicion_horizontal, 0.0, 1.0, duracion_salto)
	
	# 2. Movimiento vertical parabólico (subir y bajar)
	tween_actual.tween_method(actualizar_altura_parabolica, 0.0, 1.0, duracion_salto)
	
	# 3. Efecto de rotación durante el salto
	#tween_actual.tween_method(actualizar_rotacion_salto, 45.0, 45.0, duracion_salto)
	
	# 4. Escala durante el salto (opcional)
	tween_actual.tween_method(actualizar_escala_salto, 1.0, 1.2, duracion_salto * 0.5)
	tween_actual.tween_method(actualizar_escala_salto, 1.2, 1.0, duracion_salto * 0.5).set_delay(duracion_salto * 0.5)
	
	# Esperar a que termine el salto
	await tween_actual.finished
	esta_saltando = false

# Método para movimiento horizontal (lineal)
func actualizar_posicion_horizontal(t: float):
	# Interpolación lineal entre posición inicial y final
	var nueva_pos = posicion_inicial.lerp(posicion_final, t)
	owner.global_position.x = nueva_pos.x
	owner.global_position.z = nueva_pos.z

# Método para altura parabólica (efecte de salto)
func actualizar_altura_parabolica(t: float):
	# Función parabólica: t * (1 - t) * altura * 4
	# Esto crea una curva que sube y baja suavemente
	var altura_actual = sin(t * PI) * altura_salto  # Usando seno para curva suave
	owner.global_position.y = posicion_inicial.y + altura_actual

# Efecto de rotación durante el salto
func actualizar_rotacion_salto(angulo: float):
	if pieza and pieza.has_method("giro"):
		pieza.giro(angulo)

# Efecto de escala (opcional, para dar sensación de salto)
func actualizar_escala_salto(escala: float):
	owner.scale = Vector3(escala, escala, escala)

# Función para saltar por encima de obstáculos
#func saltar_paso():
	##var i = 0
	#print("paso: ", paso)
	## Buscar una dirección alternativa
	#while (paso<len(secuencia) and !esValida):
	##for i in range(1, len(secuencia)):
		#cambio_estado(paso)
		#var cambio = direccion * GlobalJuego.espaciado_baldosas
		#if owner.verificar_proximo_paso(cambio):
			#esValida = true
			#realizar_salto_parabolico(cambio)
			#return
		#else:
			#paso+=1
	#print(" No hay movimientos válidos para el caballo")

func cambio_estado(cambio):
	match cambio:
		0: # Quieto
			direccion = Vector3i(0, 0, 0)
			if pieza and pieza.has_method("giro"):
				pieza.giro(45)
		1: # arriba 1
			direccion = Vector3i(1, 0, -2)
			if pieza and pieza.has_method("giro"):
				pieza.giro(225)
		2: # arriba 2
			direccion = Vector3i(2, 0, -1)
			if pieza and pieza.has_method("giro"):
				pieza.giro(225)
		3: # derecha 1
			direccion = Vector3i(1, 0, 2)
			if pieza and pieza.has_method("giro"):
				pieza.giro(135)
		4: # derecha 2
			direccion = Vector3i(2, 0, 1)
			if pieza and pieza.has_method("giro"):
				pieza.giro(135)
		5: # abajo 1
			direccion = Vector3i(-2, 0, 1)
			if pieza and pieza.has_method("giro"):
				pieza.giro(45)
		6: # adelante 2
			direccion = Vector3i(-1, 0, 2)
			if pieza and pieza.has_method("giro"):
				pieza.giro(45)
		7: # izquierda 1
			direccion = Vector3i(-2, 0, -1)
			if pieza and pieza.has_method("giro"):
				pieza.giro(-45)
		8: # izquierda 2
			direccion = Vector3i(-1, 0, -2)
			if pieza and pieza.has_method("giro"):
				pieza.giro(-45)
