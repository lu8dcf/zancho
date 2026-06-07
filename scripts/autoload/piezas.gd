extends Node

# Variables de las piezas
# 0 Rey , 1 Peon , 2 Alfil , 3 Torre , 4 Caballo , 5 Reina

var vida = [1000,80,100,250,120,400]
var danio = [5,10,20,15,20,30]

var bonus_cantidad = [1,1.3,1.3,1.5,1.5,1.5]
var bonus_a=[0,4,3,1,5,2]

#texturas de los modelos
#var material_bueno = "res://assets/modelos/texturas/material_buenos.tres"
#var material_malo = "res://assets/modelos/texturas/material_malos.tres"

var material_bueno = "res://assets/modelos/texturas/material_malos.tres"
var material_malo = "res://assets/modelos/texturas/material_buenos.tres"
var material_muerte ="res://assets/modelos/texturas/material_muerte.tres"

# las piezas que estan activas en la partida
var pieza_blanca: Array[RigidBody3D] = []
var pieza_negra: Array[RigidBody3D] = []

func buscar_color(id_buscar : int) -> bool:
	for pieza_b in pieza_blanca:
		if id_buscar == pieza_b.id:
			return true
	return false

func buscar_tipo(id_buscar : int):
	for pieza_b in pieza_blanca:
		if id_buscar == pieza_b.id:
			return pieza_b.pieza_tipo
	
	for pieza_b in pieza_negra:
		if id_buscar == pieza_b.id:
			return pieza_b.pieza_tipo

# Elimina una pieza blanca de la lista segun su id
func eliminar_pieza(id_buscar):
	for pieza_b in pieza_blanca:
		if id_buscar == pieza_b.id:
			pieza_blanca.erase(pieza_b) # elimina la pieza
			return true
	return false
		
		
func informar_fin_ataque(ganador,perdedor): # Tipo ganador
	if GlobalJuego.empezo_oleada:
		GlobalSignal.finAtaque.emit(buscar_tipo(ganador),buscar_color(ganador),buscar_tipo(perdedor))
	
	#print (buscar_tipo(ganador)," ",buscar_color(ganador)," ",buscar_tipo(perdedor))
			
			


# manejo de colocacion de piezas

var pieza_seleccionada: Dictionary = {
	"tipo":-1,
	"nombre":"",
	"activa":false
}
var pieza_flotante : Node3D = null # la pieza que sostiene el mouse
var modo_colocacion : bool = false # activar o desactivar el modo colcoacion

var piezas_ataques = [
	{0:[Vector3i(-1,0,-1),Vector3i(0,0,-1),Vector3i(1,0,-1),Vector3i(-1,0,0),Vector3i(1,0,0),Vector3i(-1,0,1),Vector3i(0,0,1),Vector3i(1,0,1)]},
	{1:[Vector3i(0,0,-1),Vector3i(1,0,0)]},
	{2:[Vector3i(-1,0,-1),Vector3i(1,0,-1),Vector3i(-1,0,1),Vector3i(1,0,1)]},
	{3:[Vector3i(0,0,-1),Vector3i(1,0,0),Vector3i(0,0,1),Vector3i(-1,0,0)]},
	{4:[Vector3i(-2,0,-1),Vector3i(-1,0,-2),Vector3i(1,0,-2),Vector3i(2,0,-1),Vector3i(2,0,1),Vector3i(1,0,2),Vector3i(-1,0,2),Vector3i(-2,0,1)]},
	{5:[Vector3i(-1,0,-1),Vector3i(0,0,-1),Vector3i(1,0,-1),Vector3i(-1,0,0),Vector3i(1,0,0),Vector3i(-1,0,1),Vector3i(0,0,1),Vector3i(1,0,1)]},
]

@warning_ignore("unused_signal")
signal modo_colocacion_inicia(tipo_pieza:int,nombre:String)
@warning_ignore("unused_signal")
signal modo_colocacion_cancelado
@warning_ignore("unused_signal")
signal pieza_colocada(tipo:int, posicion:Vector2i)
@warning_ignore("unused_signal")
signal pieza_colocada_inventario(nombre_pieza: String) 
@warning_ignore("unused_signal")
signal  pieza_flotante_actualizada(posicion_3d :Vector3, es_valido:bool)

func reiniciar_variables():
	pieza_negra=[]
	pieza_blanca=[]
	pieza_seleccionada = {
		"tipo":-1,
		"nombre":"",
		"activa":false
	}
	pieza_flotante = null
	modo_colocacion = false
	

func obtener_ataques_pieza(tipo: int) -> Array:
	for i in piezas_ataques:
		if i.has(tipo):
			return i[tipo]
	return []
	
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
	
	if nombre.is_empty():
		print("Error: nombre de pieza vacío")
		cancelar_modo_colocacion()
		return false
		
	if not economia.usar_pieza(nombre):
		print("No se pudo usar la pieza: ", nombre)
		return false
	# se crea la pieza
	GlobalSignal.crearPieza.emit(posicion, tipo, true)  # true = pieza blanca (jugador)
	
	pieza_colocada.emit(tipo, posicion)
	pieza_colocada_inventario.emit(nombre)
	#verificar si quedan mas en el inventario apra seguir colocando
	var cantidad_restante = economia.inventario_actual.get(nombre, 0)
	
	if cantidad_restante > 0:
		pieza_seleccionada["cantidad"] = cantidad_restante
		return true
	else:
		# cancelar modo colocación
		cancelar_modo_colocacion()
		return true


func contar_piezas_blancas() -> int:
	return get_tree().get_nodes_in_group("pieza_blanca").size()

func contar_piezas_negras() -> int:
	return get_tree().get_nodes_in_group("pieza_negra").size()	
