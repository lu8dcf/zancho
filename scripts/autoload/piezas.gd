extends Node

# Variables de las piezas
# 0 Rey , 1 Peon , 2 Alfil , 3 Torre , 4 Caballo , 5 Reina

var vida = [1000,50,80,250,120,400]
var danio = [5,10,35,15,25,50]
var cadencia = [1,0.7,1,0.5,1.2,1.5]
var bonus_cantidad = [1,1.3,1.3,1.5,1.5,1.5]
var bonus_a=[0,4,3,1,5,2]


# Variables de la partida
var pieza_b_id = 0
var pieza_n_id = 0
var pieza_b_sitio : Array[Vector2i] = [] 
var pieza_n_sitio : Array[Vector2i] = [] 
var pieza_b_tipo =[]
var pieza_n_tipo = []


# las piezas que estan activas en la partida
var piezas_activas: Array[RigidBody3D] = []
