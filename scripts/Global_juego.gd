extends Node
# scripts/autoload/GameGlobal.gd
# ESTE SCRIPT ES GLOBAL - Se puede acceder desde CUALQUIER parte del juego
# Ejemplo: GameGlobal.monedas, GameGlobal.oleada_actual, etc.


var monedas: int = 500           # dinero inicial para comprar torres
var vidas: int = 20              # vidas del castillo/jugador
var vidaMax: int = 20
var oleada_actual: int = 1       # numero de oleada actual

# Configuración de tienda
var piezas_disponibles: Array = [
	{"nombre": "Torre Flecha", "precio": 100},
	{"nombre": "Torre Magia", "precio": 200},
	{"nombre": "Torre Cañón", "precio": 150},
	{"nombre": "Torre Hielo", "precio": 180}
]

# estado de la tienda (si esta desplegada o no)
var tienda_desplegada: bool = false


# señales para modificar el hud

signal monedas_cambiadas(nuevas_monedas)
signal vidas_cambiadas(nuevas_vidas)
signal oleada_cambiada(nueva_oleada)
signal tienda_estado_cambiado(desplegada)


# funciones para modificar
func añadir_monedas(cantidad: int) -> void:
	monedas += cantidad
	emit_signal("monedas_cambiadas", monedas)  # Notificar al HUD que cambió

func gastar_monedas(cantidad: int) -> bool:
	if monedas >= cantidad:
		monedas -= cantidad
		emit_signal("monedas_cambiadas", monedas)
		return true
	return false  # No hay suficiente dinero

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
	
	
	
