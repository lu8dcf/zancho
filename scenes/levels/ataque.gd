extends Node3D

var pares_almacenados = {}

const ATAQUE_BASE = preload("res://scenes/levels/ataque/ataque_base.tscn")


func _ready() -> void:
	limpiar_todo()
	GlobalSignal.connect("ataque",iniciaAtaque)
	GlobalSignal.connect("finalizaOleada",finalizaOleada)
	
# A= Atacante  , D= defensor
func iniciaAtaque(idA,idD,posicionA,posicionD,tipoA,tipoD):
	
	if _crear_clave(idA, idD)==false:
		return
	#print (idA," ",idD," ",posicionA," ",posicionD)
	GlobalSignal.controlMarcaPaso.emit(false) #detiene el paso del juego
	
	angulo_enfrentamiento(idA,idD,posicionA,posicionD)
	
	var nuevo_ataque = ATAQUE_BASE.instantiate()
			
	nuevo_ataque.idA = idA
	nuevo_ataque.idD = idD
	nuevo_ataque.danioA = calcular_danio(tipoA,tipoD)
	nuevo_ataque.danioD = calcular_danio(tipoD,tipoA)
			
	add_child(nuevo_ataque)
	
	
	
func calcular_danio(tipoA,tipoD):
	var danio= Piezas.danio[tipoA]
	if Piezas.bonus_a[tipoA]==tipoD:
		danio = Piezas.bonus_cantidad[tipoA] * danio
		
	return danio	
	
	
	
	
func _crear_clave(a, b): ## Genera una clave única que ignora el orden
	var clave = _generar_clave(a, b)
	
	if not pares_almacenados.has(clave):
		pares_almacenados[clave] = {"valor1": a,"valor2": b}
		return true  # Se almacenó
	return false  # Ya existía


## Elimina un par específico
func eliminar_par(a: int, b: int):
	var clave = _generar_clave(a, b)
	if pares_almacenados.has(clave):
		pares_almacenados.erase(clave)
		
		contar_pares()
		#print ("contar pares",a," ",b)
		
	return false
	
	
## Cuenta cuántos pares únicos hay
func contar_pares():
	if pares_almacenados.size() == 0:
		#print (pares_almacenados.size())
		GlobalSignal.controlMarcaPaso.emit(true)

## Limpia todos los pares
func limpiar_todo():
	pares_almacenados.clear()

	
## Genera una clave única que ignora el orden
func _generar_clave(a: int, b: int) -> String:
	# Ordenamos los números para que (1,2) y (2,1) generen la misma clave
	var menor = min(a, b)
	var mayor = max(a, b)
	return str(menor) + "|" + str(mayor)


func angulo_enfrentamiento(idA,idD,posicionA: Vector3,posicionD: Vector3):
	var dir = Vector2(posicionD.x - posicionA.x, posicionD.z - posicionA.z)
	var giro=(atan2(dir.y, dir.x))
	
	# Girar las piezas
	GlobalSignal.giro_pieza.emit(idA,giro-PI)
	GlobalSignal.giro_pieza.emit(idD,giro)
	#print (giro)

func finalizaOleada(_estado):
	limpiar_todo()  # limpia todas las batallas
	GlobalSignal.controlMarcaPaso.emit(false) # parar el marca paso
	Piezas.pieza_blanca=[]  # eliminar la lista de instancia
	Piezas.pieza_negra=[]  # eliminar la lista de instancia
	
