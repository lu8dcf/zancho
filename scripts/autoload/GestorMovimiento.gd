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
	imprimir_tablero()
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
		if (pieza in Piezas.pieza_blanca and pieza.soyReina()) or pieza in Piezas.pieza_negra:
			pieza.comienzoAtaquePorOrden()
			await get_tree().create_timer(0.2).timeout
			var se_mueve = GlobalSignal.decision_terminada
	estadoActual = estadosGestor.EN_TURNO
	await get_tree().process_frame
	GlobalSignal.emit_signal("listoParaMover")
	limpiarCasillasOcupadas()


# ============================================================
# RESERVAS
# ============================================================

func ocupar_casilla(sitio: Vector2i) -> void:
	if sitio not in casillas_ocupadas:
		casillas_ocupadas.append(sitio)


func esta_ocupada(sitio: Vector2i) -> bool:
	return sitio in casillas_ocupadas


func limpiarCasillasOcupadas() -> void:
	print("casillasResr: ", casillas_ocupadas)

	casillas_ocupadas.clear()

	estadoActual = estadosGestor.ESPERANDO_MARCAPASO


# ============================================================
# PIEZAS ESTÁTICAS
# ============================================================

func agregoLasPiezasStaticas() -> void:

	# Las piezas ya deberían tener su pieza_sitio actualizado
	# con un Vector2i.
	var piezasStaticas = Piezas.pieza_blanca
	for pieza in piezasStaticas:
		var sitio: Vector2i = pieza.pieza_sitio
		ocupar_casilla(sitio)


# ============================================================
# COMPROBACIÓN DE CASILLA
# ============================================================

func verifico_proximo(sitio: Vector2i) -> bool:

	# Si hay una pieza blanca
	if not verifica_piezas_blanca(sitio):
		return true

	# Si hay una pieza negra
	if not verifica_piezas_negra(sitio):
		return true

	# Si está fuera del tablero o hay obstáculo
	if not verifico_externos(sitio):
		return true

	# Si ya fue reservada por otra pieza
	if esta_ocupada(sitio):
		return true

	# La casilla está libre
	return false


func verifico_soloPiezas(sitio: Vector2i) -> bool:

	if not verifica_piezas_blanca(sitio):
		return false

	if not verifica_piezas_negra(sitio):
		return false

	return true


# ============================================================
# PIEZAS
# ============================================================

func verifica_piezas_blanca(sitio: Vector2i) -> bool:

	for pieza in Piezas.pieza_blanca:

		if pieza.pieza_sitio == sitio:
			print("lugar ocupadoB", sitio)
			return false

	return true


func verifica_piezas_negra(sitio: Vector2i) -> bool:

	for pieza in Piezas.pieza_negra:

		if pieza.pieza_sitio == sitio:
			print("lugar ocupadoN", sitio)
			return false

	return true


func proximaPiezaSeMueve(sitio: Vector2i) -> bool:

	for pieza in Piezas.pieza_negra:

		if pieza.pieza_sitio == sitio and pieza.yaElegiProx:
			return true

	return false


func resetearProxLugar(pieza) -> void:
	pieza.yaElegiProx = false


# ============================================================
# TABLERO
# ============================================================

func verifico_externos(sitio: Vector2i) -> bool:

	if not verifica_obstaculos(sitio):
		return false

	if not verifica_extremos(sitio):
		return false

	return true


func verifica_extremos(sitio: Vector2i) -> bool:

	if sitio.x < 0 or sitio.x > 15:
		return false

	if sitio.y < 0 or sitio.y > 15:
		return false

	return true


func verifica_obstaculos(sitio: Vector2i) -> bool:

	if sitio in mapas.mapas[GlobalJuego.mapa_actual]:
		return false

	return true



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
			# --------------------------------
			# Obstáculo
			# --------------------------------
			if sitio in mapas.mapas[GlobalJuego.mapa_actual]:
				simbolo = "X"
			# --------------------------------
			# Casillas reservadas
			# --------------------------------
			if sitio in casillas_ocupadas:
				simbolo = "*"
			# -------------------------------
			# Piezas negras
			# --------------------------------
			for pieza in Piezas.pieza_negra:
				if pieza.pieza_sitio == sitio:
					simbolo = "N"
					break
			# --------------------------------
			# Piezas blancas
			# --------------------------------
			for pieza in Piezas.pieza_blanca:
				if pieza.pieza_sitio == sitio:
					if pieza.soyReina():
						simbolo = "R"
					else:
						simbolo = "B"
					break
			fila += " " + simbolo + " "
		print(fila)
	print("=====================================")
	print("")
