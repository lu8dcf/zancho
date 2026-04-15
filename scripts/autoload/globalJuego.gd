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

# mapa
var mapa = 0

# Oleadas
var tiempo_pasos = 1.0   # tiempo entre cada movimento

# señales para modificar el hud

signal vidas_cambiadas(nuevas_vidas)
signal oleada_cambiada(nueva_oleada)
signal tienda_estado_cambiado(desplegada)


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
	
func mensaje(texto: String):
	print (texto)
	
func reiniciar_variables():
	Piezas.piezas_activas = []
