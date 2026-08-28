extends Node

enum estadosGestor {
	EN_TURNO,
	ESPERANDO_MARCAPASO,
	DESIGNANDO_CASILLAS
}

var estadoActual = estadosGestor.ESPERANDO_MARCAPASO

# Todas las casillas del tablero se manejan como Vector2i
var casillas_ocupadas: Array[Vector2i] = []
func _ready() -> void:
	GlobalSignal.connect("marcaPaso", comienzoTurno)

func comienzoTurno():
	#imprimir_tablero()
	if estadoActual != estadosGestor.ESPERANDO_MARCAPASO:
		return
	estadoActual = estadosGestor.DESIGNANDO_CASILLAS
	# Primero registramos las piezas que no se van a mover
	agregoLasPiezasStaticas()
	var listaPiezas = Piezas.pieza_negra
	var reinaPieza = Piezas.buscoYRetornoReina()
	if reinaPieza != null:
		listaPiezas.append(reinaPieza)
	# Cada pieza decide su próximo movimiento
	for pieza in listaPiezas:
		pieza.comienzoAtaquePorOrden()
		await get_tree().create_timer(0.2).timeout
		#var se_mueve = GlobalSignal.decision_terminada
	estadoActual = estadosGestor.EN_TURNO
	await get_tree().process_frame
	GlobalSignal.emit_signal("listoParaMover")
	limpiarCasillasOcupadas()


# RESERVAS

func ocupar_casilla(sitio) -> void:
	var sitio2d := convertir_a_sitio2d(sitio)
	if sitio2d not in casillas_ocupadas:
		casillas_ocupadas.append(sitio2d)
	#print("RESERVO:", sitio2d)
	#print("CASILLAS:", casillas_ocupadas)

func esta_ocupada(sitio) -> bool:
	var sitio2d = convertir_a_sitio2d(sitio)
	if(sitio2d in casillas_ocupadas):
		return true
	return false

func limpiarCasillasOcupadas() -> void:
	#print("casillasResr: ", casillas_ocupadas)
	casillas_ocupadas.clear()
	estadoActual = estadosGestor.ESPERANDO_MARCAPASO


# PIEZAS ESTATICAS

func agregoLasPiezasStaticas() -> void:

	# Las piezas ya deberíian tener su pieza_sitio actualizado
	# con un Vector2i.
	var piezasStaticas = Piezas.pieza_blanca
	for pieza in piezasStaticas:
		var sitio: Vector2i = pieza.pieza_sitio
		ocupar_casilla(sitio)


# COMPROBACIoN DE CASILLA

func verifico_proximo(sitio) -> bool:
	var sitio2d = convertir_a_sitio2d(sitio)
	if hay_piezas_blancas_en_el_sitio(sitio2d):
		return true
	if hay_pieza_negra_en_el_sitio(sitio2d):
		return true
	if not verifico_externos(sitio2d):
		return true
	if esta_ocupada(sitio2d):
		return true
	return false


func verifico_soloPiezas(sitio) -> bool:
	var sitio2d = convertir_a_sitio2d(sitio)
	if hay_piezas_blancas_en_el_sitio(sitio2d):
		return true
	if hay_pieza_negra_en_el_sitio(sitio2d):
		return true
	return false

# PIEZAS
func hay_piezas_blancas_en_el_sitio(sitio: Vector2i) -> bool:
	if sitio in casillas_ocupadas:
			#print("lugar ocupadoB", sitio)
			return true
	return false


func hay_pieza_negra_en_el_sitio(sitio: Vector2i) -> bool:
	
	if sitio in casillas_ocupadas:
			#print("lugar ocupadoN", sitio)
			return true
	return false


func proximaPiezaSeMueve(sitio: Vector2i) -> bool:
	for pieza in Piezas.pieza_negra:
		if pieza.pieza_sitio == sitio and pieza.yaElegiProx:
			return true

	return false


func resetearProxLugar(pieza) -> void:
	pieza.yaElegiProx = false

# TABLERO

func verifico_externos(sitio) -> bool:
	var sitio2d = convertir_a_sitio2d(sitio)
	if not verifica_obstaculos(sitio2d):
		return false
	if not verifica_extremos(sitio2d):
		return false
	return true


func verifica_extremos(sitio) -> bool:
	var sitio2d = convertir_a_sitio2d(sitio)
	if sitio2d.x < 0 or sitio2d.x > 15:
		return false
	if sitio2d.y < 0 or sitio2d.y > 15:
		return false
	return true


func verifica_obstaculos(sitio) -> bool:
	var sitio2d = convertir_a_sitio2d(sitio)
	if sitio2d in mapas.mapas[GlobalJuego.mapa_actual]:
		return false
	return true
	
func convertir_a_sitio2d(posicion) -> Vector2i:
	if posicion is Vector2i:
		return posicion
	if posicion is Vector3i:
		return Vector2i(
			posicion.x,
			posicion.z
		)
	if posicion is Vector2:
		return Vector2i(
			round(posicion.x),
			round(posicion.y)
		)
	if posicion is Vector3:
		return Vector2i(
			round(posicion.x),
			round(posicion.z)
		)
	push_error("GestorMovimiento: tipo de posición no reconocido: " + str(posicion))
	return Vector2i.ZERO


func imprimir_tablero() -> void:
	var ancho := 16
	var alto := 16
	print("")
	print("============== TABLERO ==============")
	# Encabezado de columnas
	var encabezado := "    "
	for x in range(ancho):
		encabezado += "%2d " % x
	print(encabezado)
	# Filas
	for y in range(alto):
		var fila := "%2d | " % y
		for x in range(ancho):
			var sitio := Vector2i(x, y)
			var simbolo := "."
			# Obstaculo
			if sitio in mapas.mapas[GlobalJuego.mapa_actual]:
				simbolo = "X"
			# Casillas reservadas
			if sitio in casillas_ocupadas:
				simbolo = "*"
			# Piezas negras
			for pieza in Piezas.pieza_negra:
				if pieza.pieza_sitio == sitio:
					simbolo = "N"
					break
			# Piezas blancas
			for pieza in Piezas.pieza_blanca:
				if pieza.pieza_sitio == sitio:
					simbolo = "B"
					break
			fila += " " + simbolo + " "
		print(fila)
	print("=====================================")
	print("")
