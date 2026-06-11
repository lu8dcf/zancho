extends Node
class_name ReinaN

var pasos=0 #cantidad dee pasos que dara para cambio de  secuencia 

# Referencia a la pieza base (el RigidBody3D que contiene este componente)
var pieza: PiezaBase
var proxima_posicion : Vector3

var objetivoRey = Vector3i(1,0,14)
var ultimoMovimiento : Vector3i = Vector3i.ZERO
var locura = 0.15 #randomiza la eleccion de sigueinte paso


# desplazamiento reinaBlanca
var direccion= Vector3i(0,0,0)
var secuencia = [0,1,2,3,4,5,6,7,8]
var paso = 0


func _ready():
	# Obtener la referencia a la pieza base (el owner del componente)
	pieza = get_parent() as PiezaBase

	# Verificar que se obtuvo correctamente
	if not pieza:
		print ("El componente REina debe ser hijo directo de una PiezaBase")
		return

	# Conectar señal después de que la pieza esté lista
	await pieza.ready
	GlobalSignal.connect("marcaPaso",movimiento	)
	
	

func distanciaAlRey(posActual):
	return abs(posActual.x- objetivoRey.x) + abs(posActual.y - objetivoRey.y)

func movimientoConPeso():
	
	var candidatos = obtenerMovimientosValidos()
	
	if candidatos.is_empty():
		return
	var movimientoElegido = elegirMovimiento(candidatos)
	ultimoMovimiento = movimientoElegido
	var cambio = movimientoElegido * GlobalJuego.espaciado_baldosas

	#realizar_salto_parabolico(cambio)
	
	#var actual = calculoPosActual()
	#var distanciaActual = distanciaAlRey(actual)

func calculoPosActual() -> Vector3i:
	var actual = Vector3i(
	round(owner.global_position.x / GlobalJuego.espaciado_baldosas),
	0,
	round(owner.global_position.z / GlobalJuego.espaciado_baldosas))
	return actual
	
func obtenerMovimientosValidos():
	var movimientosDisponibles = [
		 # Quieto
			#Vector3i(0, 0, 0),
		# arriba 1
			Vector3i(1, 0, -2),
		# arriba 2
			Vector3i(2, 0, -1),
		# derecha 1
			Vector3i(1, 0, 2),
		# derecha 2
			Vector3i(2, 0, 1),
		# abajo 1
			Vector3i(-2, 0, 1),
		# adelante 2
			Vector3i(-1, 0, 2),
		# izquierda 1
			Vector3i(-2, 0, -1),
		# izquierda 2
			Vector3i(-1, 0, -2)
	]
	var candidatos = []
	for mov in movimientosDisponibles:
		var pasoSiguiente = mov*GlobalJuego.espaciado_baldosas
		if not es_valido(pasoSiguiente):
			continue
		var peso = calcularPesoMovimiento(mov)
		candidatos.append({
			"direccion": direccion,
			"peso": peso
		})
	return candidatos
	
func es_valido(pos: Vector3i) -> bool: #me aseguro que se pueda usar la baldosa
	var pos2d = Vector2i(pos.x, pos.z)
	if globalJuego.verifica_extremos(pos2d)==false:
		return false
	if globalJuego.verifica_obstaculos(pos2d)==false:
		return false
	if globalJuego.verifica_piezas(pos2d)==false:
		return false
	return true
	
	
func calcularPesoMovimiento(mov: Vector3i):
	var peso = 0
	peso+=pesoDistanciaRey(mov)
	peso +=pesoPorMemoria(mov)
	peso += pesoPorLocura()
	
	return max(1,peso)

func pesoDistanciaRey(mov: Vector3i):
	#var actual = calculoPosActual()
	var nueva = calculoPosActual() + Vector3i(mov.x,0,mov.z)
	var distanciaActual = distanciaAlRey(calculoPosActual())
	var distancia_nueva = distanciaAlRey(nueva)
	var mejora = distanciaActual-distancia_nueva
	return pesoPorMejora(mejora)
	#match(mejora):
			#_ when mejora>=4: #_ acepta el valor que tenga la variable
				#return 100
			#_ when mejora>=2: #when es un filtro, solo se ejecuta si la siguiente sentencia es true
				#return 50
			#_ when mejora>=1:
				#return 25
			#_ when mejora == 0:
				#return 10
			#_:
				#return 3

func pesoPorMejora(mejora):
	if mejora >= 4:
		return 100

	if mejora >= 2:
		return 50

	if mejora >= 1:
		return 25

	if mejora == 0:
		return 10

	return 3

func pesoPorMemoria(mov: Vector3i):
	if mov == ultimoMovimiento:
		return -20
	if (mov == -ultimoMovimiento):
		return -50
	return 0
	
func pesoPorLocura():
	if randf()<locura:
		return randi_range(0,40)
	return 0

func elegirMovimiento(candidatos):
	var peso_total = 0
	for candidato in candidatos:
		peso_total += candidato["peso"]
	var tirada = randf() * peso_total
	var acumulado = 0
	for candidato in candidatos:
		acumulado += candidato["peso"]
		if tirada <= acumulado:
			return candidato["direccion"]
	return candidatos[0]["direccion"]


#------------------------------------------------------------------------
	
func movimiento():
	dar_paso() #esto va a avanzar solo si el ususario clica
	# actualizacion de posicion
	var cambio = direccion*GlobalJuego.espaciado_baldosas # # vector de cambio de la pieza
	
	if owner.verificar_proximo_paso(cambio)==false:
		saltar_paso() #bordear
		return
	
	#owner.animacion_caminata("Bidle")
	#Lo siguiente es animacion
	var tween = create_tween()
	tween.tween_property(owner, "global_position", owner.global_position + cambio , 1) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN_OUT)
	
func dar_paso():
	paso+=1
	if paso==len(secuencia): paso=1
	cambio_estado(paso)
	
func saltar_paso(): # volver a iniciar en otra posicion d esalto
	movimiento()  	
	
# Estadod de la pieza
func cambio_estado(cambio):
	
	match secuencia[cambio]:
		0: # Quieto
			direccion = Vector3i(0,0,0)
			owner.giro(45)  # la balaca debe tener 225
		1: # arriba 1
			direccion = Vector3i(0,0,-1)
			owner.giro(-90)
		2:# arriba 2
			direccion = Vector3i(0,0,1)
			owner.giro(90)
		3: # derecha 1
			direccion = Vector3i(1,0,0)
			owner.giro(180)
		4: # derecha 2
			direccion = Vector3i(-1,0,0)
			owner.giro(0)
		5: # abajo 1
			direccion = Vector3i(1,0,1)
			owner.giro(135)
		6:# adelante 2
			direccion = Vector3i(-1,0,1)
			owner.giro(45)
		7: # izquierda 1
			direccion = Vector3i(-1,0,-1)
			owner.giro(-45)
		8: # izquierda 2
			direccion = Vector3i(1,0,-1)
			owner.giro(-135)
