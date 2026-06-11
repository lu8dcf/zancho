extends Node
# scripts/autoload/GameGlobal.gd
# ESTE SCRIPT ES GLOBAL - Se puede acceder desde CUALQUIER parte del juego
# Ejemplo: GameGlobal.monedas, GameGlobal.oleada_actual, etc.

### - DEBUG SI ES TRUE ENTONCES TODO ESTA PERMITIDO

var debug :bool = true

### - DEBUG SI ES TRUE ENTONCES TODO ESTA PERMITIDO

var vidas: int = 20              # vidas del castillo/jugador
var vidaMax: int = 20

var fe : int = 20
var feMax : int = 20
var oleada_actual: int = 1       # numero de oleada actual
var mapa_actual: int = 1        # numero de mapa activo

# estado de la tienda (si esta desplegada o no)
var tienda_desplegada: bool = false

# tablero
var tamano_tablero : Vector2i = Vector2i(16, 16)
var espaciado_baldosas : float = 2.0


# Oleadas
var tiempo_pasos = 4.0   # tiempo entre cada movimento
var empezo_oleada = false # si es que empezo la oleada
var valores_antes_empezar_oleada = []

# señales para modificar el hud
var juego_pausa = false

# Ataques
var tiempo_ataque = 1 # timepo de cada ataque

#lista piezas
var casillas_reservadas = []

signal vidas_cambiadas(nuevas_vidas)
signal oleada_cambiada(nueva_oleada)
signal tienda_estado_cambiado(desplegada)
signal mapa_cambiado(nuevo_mapa: int)
signal fe_cambiada(nueva_fe)

func perder_vida(cantidad: int = 1) -> void:
	vidas -= cantidad
	emit_signal("vidas_cambiadas", vidas)
	
	if vidas <= 0:
		print("se termino la vida")


func perder_fe(cantidad: int = 1) -> void:
	fe -= cantidad
	emit_signal("fe_cambiada", fe)
	print("cuanta fe queda: ", fe, feMax)
	
	if fe <= 0:
		print("se perdio toda la fe")
		
func siguiente_oleada() -> void:
	oleada_actual += 1
	emit_signal("oleada_cambiada", oleada_actual)

func alternar_tienda() -> void:
	tienda_desplegada = !tienda_desplegada
	emit_signal("tienda_estado_cambiado", tienda_desplegada)

func juego_terminado() -> void:
	print("¡Juego terminado! Llegaste a la oleada ", oleada_actual)

# si cambia el mapa, cambian las ubicaciones de los objetos segun el mapa
func cambiar_mapa(nuevo_indice: int) -> bool:
	if nuevo_indice > 0:
		mapa_actual = nuevo_indice
		mapa_cambiado.emit(nuevo_indice)
		return true
	return false

func lugar_disponible(sitio: Vector2i):
	if verifica_obstaculos(sitio)==false:
		return false
	if verifica_extremos(sitio)==false:
		return false
	if verifica_piezas_blanca(sitio)==false: 
		return false
	#if verifica_piezas_negra(sitio)==false: 
		#return false
	return true
	
	
func verifico_casillas_reservadas(sitio: Vector2i, antiguoSitio: Vector2i): #le paso la nueva pos y al actual
	if sitio in casillas_reservadas: #si esta reservada, no se puede ocupar
		return false
	else:
		borroPiezaSitio(sitio,antiguoSitio)
		casillas_reservadas.append(sitio) #si no, se agrega a las reservadas
		casillas_reservadas.erase(antiguoSitio) #y se borra la actual
		return true
		
func borroPiezaSitio(sitio: Vector2i, antiguoSitio: Vector2i):
	for pieza in Piezas.pieza_negra:
		if pieza.pieza_sitio == antiguoSitio:
			pieza.pieza_sitio = sitio

func verifica_piezas(sitio: Vector2i):
	if verifica_piezas_blanca(sitio)==false: return false
	if verifica_piezas_negra(sitio)==false: return false
	return true
	
func verifica_piezas_blanca(sitio: Vector2i)-> bool:	
	for pieza in Piezas.pieza_blanca:
		if pieza.pieza_sitio == sitio:
			#print ("lugar ocupado")
			return false
	return true

func verifica_piezas_negra(sitio: Vector2i)-> bool:	
	for pieza in Piezas.pieza_negra:
		if pieza.pieza_sitio == sitio:
			#print ("lugar ocupado")
			return false
	return true


func actualizar_todas_las_piezas():
	for pieza in Piezas.pieza_negra:
		var sitio3d = round(pieza.global_position) / globalJuego.espaciado_baldosas
		pieza.pieza_sitio = Vector2i(sitio3d.x, sitio3d.z)

func limpio_reservadas():
	print(casillas_reservadas)
	casillas_reservadas.clear()
		
func verifica_extremos(sitio: Vector2i):	
	if sitio.x > 15 or sitio.x < 0 or sitio.y >15 or sitio.y <0:
		#mensaje(" La posición esta fuera del tablero ")	
		return false
	return true
	
func verifica_obstaculos(sitio: Vector2i):
	# Verificacion de obstaculos en el mapa
	if sitio in mapas.mapas[globalJuego.mapa_actual]:
		#mensaje("No se puede insertar sobre un obstaculo")
		return false
	return true
	
func colocar_blanca(sitio: Vector2i):
	if not lugar_disponible(sitio):
		return false
	
	# sector de spawn negras
	if (sitio.y<2 and sitio.x>7) or  (sitio.y==2 and sitio.x>8) or (sitio.y==3 and sitio.x>9) or (sitio.y==4 and sitio.x>10) or (sitio.y==5 and sitio.x>11) or (sitio.y==6 and sitio.x>12) or (sitio.y==7 and sitio.x>13):
		return false
	return true


func reiniciar_variables():
	vidas = 20
	fe = 20
	oleada_actual = 1
	mapa_actual=1
	Piezas.reiniciar_variables()
	mapas.reiniciar_variables()
	economia.reiniciar_variables()
	juego_pausa = false
	
	
func mensaje(texto):
	print (texto)
