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
	cargar_todos_mapas()		
	# Mapa 0
		#0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
   #┌───────────────────────────────────────────────┐
 #0 │ .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . │
 #1 │ .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . │
 #2 │ .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . │
 #3 │ .  .  X  .  .  .  .  .  .  .  .  .  .  .  .  . │  ← Vector2i(2, 3)
 #4 │ .  .  .  .  .  .  .  .  .  .  X  .  .  .  .  . │  ← Vector2i(10, 4)
 #5 │ .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . │
 #6 │ .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . │
 #7 │ .  .  .  .  .  X  .  .  .  .  .  .  .  .  .  . │  ← Vector2i(5, 7)
 #8 │ .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . │
 #9 │ .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . │
#10 │ .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . │
#11 │ .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . │
#12 │ .  .  .  .  .  .  .  .  X  .  .  .  .  .  .  . │  ← Vector2i(8, 12)
#13 │ .  .  .  .  .  .  .  .  X  .  .  .  .  .  .  . │  ← Vector2i(8, 13)
#14 │ .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . │
#15 │ .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . │
   #└───────────────────────────────────────────────┘
	
func cargar_todos_mapas():
	mapas.clear()
	obstaculos.clear()
	
	for i in range(5):
		cargar_cada_mapa(i)


func cargar_cada_mapa(mapa_numero:int):
	var posiciones = []
	var tipos = []
	print("crgando mapa: ", mapa_numero)
	match mapa_numero:
		0:
			posiciones  =[
				Vector2i(2, 3), 
				Vector2i(5, 7),
				Vector2i(10, 4),
				Vector2i(8, 12),
				Vector2i(8, 13)
			]
			tipos =[1,  #  objeto 1 en posición (2,3)
					2,  # objeto 2 en posición (5,7)
					1,  # objeto 1 en posición (10,4)
					3,   # objeto 3 en posición (8,12),
					2
			]
		1: 
			posiciones = [
				Vector2i(2, 3), 
				Vector2i(5, 7),
				Vector2i(10, 4)
			]
			tipos = [1, 2, 1]
		2: 
			posiciones = [
				Vector2i(3, 3),
				Vector2i(4, 4),
				Vector2i(5, 5)
			]
			tipos = [1, 1, 1]
		3: 
			posiciones = [
				Vector2i(2, 2),
				Vector2i(6, 6),
				Vector2i(10, 10)
			]
			tipos = [2, 2, 2]
		4: 
			posiciones = [
				Vector2i(7, 7),
				Vector2i(8, 8)
			]
			tipos = [3, 3]
		
	mapas.append(posiciones)
	obstaculos.append(tipos)

func obtener_mapa_actual(indice_mapa: int = 0) -> Dictionary:
	if indice_mapa < 0 or indice_mapa >= mapas.size():
		return {"posiciones": [], "tipos": []}
	
	return {
		"posiciones": mapas[indice_mapa],
		"tipos": obstaculos[indice_mapa]
	}

#func es_posicion_bloqueada(posicion: Vector2i, indice_mapa: int = 0) -> bool:
	#if indice_mapa < 0 or indice_mapa >= mapas.size():
		#return false
	#return posicion in mapas[indice_mapa]

func siguiente_mapa() -> void:
	var nuevo_mapa = (globalJuego.mapa_actual + 1) % mapas.size()
	globalJuego.cambiar_mapa(nuevo_mapa)

func mapa_anterior() -> void:
	var nuevo_mapa = (globalJuego.mapa_actual - 1 + mapas.size()) % mapas.size()
	globalJuego.cambiar_mapa(nuevo_mapa)
