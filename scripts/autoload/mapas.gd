# Mapas.gd - Autoload
extends Node

# Diccionario de objetos posibles
var mapas: Array[Array] = []
var obstaculos: Array[Array] = []

var tipo_obstaculo : Dictionary = {
	1: "res://assets/modelos/objetos/caja.glb",
	2: "res://assets/modelos/objetos/caja.glb",
	3: "res://assets/modelos/objetos/caja.glb",
	
}

func _ready():
	# posiciones donde habrá obstáculos
	mapas.append([
		Vector2i(2, 3), 
		Vector2i(5, 7),
		Vector2i(10, 4),
		Vector2i(8, 12),
		Vector2i(8, 13)
	])
	
	#  obstáculos para el mapa 0 (deben coincidir en cantidad con las posiciones)
	obstaculos.append([
		1,  #  objeto 1 en posición (2,3)
		2,  # objeto 2 en posición (5,7)
		1,  # objeto 1 en posición (10,4)
		3   # objeto 3 en posición (8,12)
	])

func obtener_mapa_actual(indice_mapa: int = 0) -> Dictionary:
	if indice_mapa >= mapas.size():
		return {"posiciones": [], "tipos": []}
	
	return {
		"posiciones": mapas[indice_mapa],
		"tipos": obstaculos[indice_mapa]
	}

func es_posicion_bloqueada(posicion: Vector2i, indice_mapa: int = 0) -> bool:
	if indice_mapa >= mapas.size():
		return false
	return posicion in mapas[indice_mapa]

func obtener_tipo_obstaculo_en_posicion(posicion: Vector2i, indice_mapa: int = 0) -> int:
	if indice_mapa >= mapas.size():
		return 0
	
	var index = mapas[indice_mapa].find(posicion)
	if index != -1 and index < obstaculos[indice_mapa].size():
		return obstaculos[indice_mapa][index]
	return 0
	
	
	
