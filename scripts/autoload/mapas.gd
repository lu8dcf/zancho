extends Node
# diccionario de objetos posibles

var mapas: Array[Array] = []
var obstaculos: Array[Array] = []


var tipo_obstaculo :Array = [
	{1: "res://assets/modelos/peon1.glb"},
	{2: "res://assets/modelos/peon1.glb"},
	{3: "res://assets/modelos/peon1.glb"},
]

func _ready():
	# Inicializar los mapas
	mapas.append([Vector2i(0, 0), Vector2i(1, 1)])  # mapa 0 (índice 0)
	obstaculos.append([2,2]) # obstaculos del mapa 0
	mapas.append([Vector2i(2, 2), Vector2i(3, 3)])  # mapa 1
	obstaculos.append([1,1])   # obstaculos del mapa 1
	mapas.append([Vector2i(4, 4), Vector2i(5, 5)])  # mapa 2
	obstaculos.append([1,2])   # obstaculos del mapa 2
	
	




 # n mapa, Ubicacion objeto, tipo objeto
var mapa1 = [
	Vector2i(2,3),
	Vector2i(2,4),
	Vector2i(2,5),
]
var objeto1 = [
	2,3,4
]
