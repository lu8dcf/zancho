extends Node
class_name ReinaN

const DISTANCIA_CAZA := 11
const DISTANCIA_ATAQUE := 3

# Referencia a la pieza base (el RigidBody3D que contiene este componente)
var pieza: PiezaBase
var proxima_posicion : Vector3

var objetivoRey = Vector3i(1,0,14)
var ultimoMovimiento : Vector3i = Vector3i.ZERO
# aumenta cuando caen defensores
var agresividad := 0
var impaciencia := 0
var piezasTotal := 0
# cantidad de defensores cuando comenzó el acecho
var defensoresIniciales := -1
# evita reinicializar
var acechoIniciado := false

# desplazamiento reinaBlanca
var direccion= Vector3i(0,0,0)

var movimientosDisponibles = [ #casillas alrededor
		#0: # Quieto
			#Vector3i(0,0,0),
		#1: # arriba 1
			Vector3i(0,0,-1),
		#2:# arriba 2
			Vector3i(0,0,1),
		#3: # derecha 1
			Vector3i(1,0,0),
		#4: # derecha 2
			Vector3i(-1,0,0),
		#5: # abajo 1
			Vector3i(1,0,1),
		#6:# adelante 2
			Vector3i(-1,0,1),
		#7: # izquierda 1
			Vector3i(-1,0,-1),
		#8: # izquierda 2
			Vector3i(1,0,-1)
	]

func _ready():
	# Obtener la referencia a la pieza base (el owner del componente)
	pieza = get_parent() as PiezaBase

	# Verificar que se obtuvo correctamente
	if not pieza:
		print ("El componente REina debe ser hijo directo de una PiezaBase")
		return

	# Conectar señal después de que la pieza esté lista
	await pieza.ready
	piezasTotal = batallasCerca()
	GlobalSignal.connect("marcaPaso",movimientoConPeso)
	

func movimientoConPeso():

	var candidatos = obtenerMovimientosValidos()
	if candidatos.is_empty():
		return
	var movimientoElegido = elegirMovimiento(candidatos)
	ultimoMovimiento = movimientoElegido
	print("MovEle:", movimientoElegido)
	print("imp:", impaciencia)
	print("agr:", agresividad)
	moverPaso(movimientoElegido)

	#var actual = calculoPosActual()
	#var distanciaActual = distanciaAlRey(actual)

func moverPaso(destino:Vector3i): #desplazo la pieza a la sieguiente
	var avanzo = Vector3(
		destino.x * GlobalJuego.espaciado_baldosas,
		0,
		destino.z * GlobalJuego.espaciado_baldosas
	)
	var tween = create_tween() #animacion y muevo
	tween.tween_property(owner, "global_position", owner.global_position + avanzo , 1) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN_OUT)
	await tween.finished

func calculoPosActual() -> Vector3i:
	var actual = Vector3i(
	round(owner.global_position.x / GlobalJuego.espaciado_baldosas),
	0,
	round(owner.global_position.z / GlobalJuego.espaciado_baldosas))
	return actual
	
func obtenerMovimientosValidos():
	var candidatos = []

	for mov in movimientosDisponibles:
		var paso = (mov * GlobalJuego.espaciado_baldosas)
		if !owner.verificar_proximo_paso(paso):
			continue
		var peso = calcularPesoMovimiento(mov)
		candidatos.append({
			"direccion": mov,
			"peso": peso
		})
	return candidatos

	
func calcularPesoMovimiento(mov):
	var distancia = distanciaAlRey(calculoPosActual())
	if(distancia > DISTANCIA_CAZA): #si la distancia es mayo a 11, su objetivo es acercarse
		return pesoCaza(mov)
	elif distancia > DISTANCIA_ATAQUE: #si la distancia ya es de ataque
		return pesoAcecho(mov) #primero rodea y espera a que bajen las desfensas
	return pesoAtaque(mov) #luego ataca
	
func pesoCaza(mov): #se enfoca en acercarse
	var peso := 0
	peso += pesoDistanciaRey(mov) * 4#prioridad 
	peso += pesoPorMemoria(mov)
	agresividadPorBatalla()
	peso += agresividad
	return peso

func pesoAcecho(mov): 
	inicializarAcecho()
	#actualizarAgresividad() #la agresividad se da cuando bajan los enemigos
	var peso := 0
	peso += pesoOrbital(mov) #pero por seguir orbitando
	agresividadPorBatalla()
	peso += agresividad * 2#pero por agresividad/ataque
	peso += impaciencia * 2 #peso por impaciencia
	peso += pesoPorMemoria(mov) #peso para no reptir pasos
	if impaciencia > 270:
		print("bastaPaciencia")
		return pesoAtaque(mov) #no hay mas paciencia, ataco
	return peso

func inicializarAcecho(): #acecho = contar defensores
	if acechoIniciado:
		return
	acechoIniciado = true

func pesoAtaque(mov): #busco acercarme y atacar
	var peso := 0
	peso += pesoDistanciaRey(mov) * 4
	peso += pesoAlineacionRey(mov)
	peso += agresividad * 2
	return peso
	
#func actualizarAgresividad(): 
	#var actuales = contarDefensoresCercanos()
	#print("defAct: ", actuales)
	#if actuales == 0: #si no hay defensores, que ataque
		#impaciencia += 15
	#var eliminados = defensoresIniciales - actuales
	#print("elimn: ", eliminados)
	#agresividad = eliminados * 25 #va a atacar cuando se queden pocos enemigos
	
func pesoOrbital(mov): #mantenerse a 5 de distancia del rey
	var nueva = posicionFutura(mov) #
	var distancia = distanciaAlRey(nueva)
	var diferencia = abs(distancia - 5)
	return max(0, 60 - diferencia * 20) #que el peso sea maximo 60, para que no gane fijo
	
func contarDefensoresCercanos(): #referencia
	var total := 0
	for piezaD in Piezas.pieza_blanca:
		var pos = piezaD.pieza_sitio
		if distanciaAlRey(Vector3i(pos.x,0,pos.y)) <= 2:
			total += 1
	return total

func agresividadPorBatalla():
	var piezasActuales = batallasCerca()
	if(piezasTotal> piezasActuales):
		agresividad+=(piezasTotal-piezasActuales)*25


func batallasCerca():
	return (Piezas.pieza_blanca.size()+Piezas.pieza_negra.size())


func posicionFutura(mov: Vector3i): #posicion mas posible siguiente posicion
	return calculoPosActual() + Vector3i(mov.x,0,mov.z)

func pesoDistanciaRey(mov: Vector3i): 
	var actual = calculoPosActual()
	var nueva = actual + mov
	var distanciaActual = distanciaAlRey(actual)
	var distanciaNueva = distanciaAlRey(nueva)
	var pesoPorDistancia = distanciaActual - distanciaNueva
	var peso = pesoPorDistanciaAlRey(pesoPorDistancia)
	return peso

func distanciaAlRey(posActual):
	return abs(posActual.x- objetivoRey.x) + abs(posActual.z - objetivoRey.z)

func pesoPorDistanciaAlRey(distancia):
	if distancia >= 2: #tiene mayor peso el que acerca mas al rey
		return 100
	if distancia == 1:
		return 50
	if distancia == 0:
		return 10
	if distancia == -1:
		return 2
	return 1

func pesoAlineacionRey(mov): #las diagonales y filasCol pesan mas
	var nueva = posicionFutura(mov)
	var dx = abs(nueva.x - objetivoRey.x)
	var dz = abs(nueva.z - objetivoRey.z)
	var peso := 0
	if nueva.x == objetivoRey.x: #arriba
		peso += 50
	if nueva.z == objetivoRey.z: #derecha
		peso += 50
	if dx == dz:#diagonal
		peso += 70
	return peso

func pesoPorMemoria(mov: Vector3i):
	if ultimoMovimiento == Vector3i.ZERO:
		return 0
	# evita ir y volver constantemente
	if mov == -ultimoMovimiento:
		impaciencia += 8
		return -50
	# penalizacion por repetir
	if mov == ultimoMovimiento:
		impaciencia += 2
		return +15
	return 0

	
func elegirMovimiento(candidatos):
	var mejor = candidatos[0]
	for candidato in candidatos:
		if candidato["peso"] > mejor["peso"]: #selecciona la opcion de mas peso
			mejor = candidato
	return mejor["direccion"]
	
