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
var pieza_activa: Array[RigidBody3D] = []

# manejo de colocacion de piezas

var pieza_seleccionada: Dictionary = {
	"tipo":-1,
	"nombre":"",
	"activa":false
}
var pieza_flotante : Node3D = null # la pieza que sostiene el mouse
var modo_colocacion : bool = false # activar o desactivar el modo colcoacion

signal modo_colocacion_inicia(tipo_pieza:int,nombre:String)
signal modo_colocacion_cancelado
signal pieza_colocada(tipo:int, posicion:Vector2i)
@warning_ignore("unused_signal")
signal  pieza_flotante_actualizada(posicion_3d :Vector3, es_valido:bool)


func iniciar_modo_colocacion(tipo_pieza: int, nombre_pieza: String) -> void:
	modo_colocacion = true
	pieza_seleccionada = {
		"tipo": tipo_pieza,
		"nombre": nombre_pieza,
		"activa": true
	}
	modo_colocacion_inicia.emit(tipo_pieza, nombre_pieza)

func cancelar_modo_colocacion() -> void:
	modo_colocacion = false
	pieza_seleccionada = {
		"tipo": -1,
		"nombre": "",
		"activa": false
	}
	modo_colocacion_cancelado.emit()

func colocar_pieza_en_posicion(posicion: Vector2i) -> bool:
	if not modo_colocacion:
		return false
	
	var tipo = pieza_seleccionada["tipo"]
	var nombre = pieza_seleccionada["nombre"]
	
	# se crea la pieza
	GlobalSignal.crearPieza.emit(posicion, tipo, true)  # true = pieza blanca (jugador)
	
	# si lo colocamos, el inventario se resta uno pero en la colocacion se suma uno
	if economia.has_method("usar_pieza"):
		economia.usar_pieza(nombre)
	
	pieza_colocada.emit(tipo, posicion)
	cancelar_modo_colocacion()
	return true
