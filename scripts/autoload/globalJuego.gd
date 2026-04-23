extends Node
# scripts/autoload/GameGlobal.gd
# ESTE SCRIPT ES GLOBAL - Se puede acceder desde CUALQUIER parte del juego
# Ejemplo: GameGlobal.monedas, GameGlobal.oleada_actual, etc.


var vidas: int = 20              # vidas del castillo/jugador
var vidaMax: int = 20
var oleada_actual: int = 1       # numero de oleada actual
var mapa_actual: int = 1         # numero de mapa activo

# estado de la tienda (si esta desplegada o no)
var tienda_desplegada: bool = false

# tablero
var tamano_tablero : Vector2i = Vector2i(16, 16)
var espaciado_baldosas : float = 2.0


# Oleadas
var tiempo_pasos = 3.0   # tiempo entre cada movimento

# señales para modificar el hud

signal vidas_cambiadas(nuevas_vidas)
signal oleada_cambiada(nueva_oleada)
signal tienda_estado_cambiado(desplegada)
signal mapa_cambiado(nuevo_mapa: int)


func perder_vida(cantidad: int = 1) -> void:
	vidas -= cantidad
	emit_signal("vidas_cambiadas", vidas)
	
	if vidas <= 0:
		juego_terminado()

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
	
	# Verificacion de obstaculos en el mapa
	if sitio in mapas.mapas[globalJuego.mapa_actual]:
		#mensaje("No se puede insertar sobre un obstaculo")
		return false	
	
	
	for pieza in Piezas.pieza_activa:
		if pieza.pieza_sitio == sitio:
			#print ("lugar ocupado")
			return false
		
			
	
	if sitio.x > 15 or sitio.x < 0 or sitio.y >15 or sitio.y <0:
		#mensaje(" La posición esta fuera del tablero ")	
		return false
	
	return true

func colocar_blanca(sitio: Vector2i):
	lugar_disponible(sitio)
	
	if (sitio.y<2 and sitio.x>7) or  (sitio.y==2 and sitio.x>8) or (sitio.y==3 and sitio.x>9) or (sitio.y==4 and sitio.x>10) or (sitio.y==5 and sitio.x>11) or (sitio.y==6 and sitio.x>12) or (sitio.y==7 and sitio.x>13):
		return false
	return true
		  

func reiniciar_variables():
	Piezas.piezas_activas = []
	
	
func mensaje(texto):
	print (texto)
