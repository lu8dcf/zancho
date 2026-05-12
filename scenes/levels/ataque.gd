extends Node3D

var pares_almacenados = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignal.connect("ataque",iniciaAtaque)
	


# A= Atacante  , D= defensor
func iniciaAtaque(idA,idD,posicionA,posicionD):
	
	if  _crear_clave(idA, idD)==false:
		return
	print (idA," ",idD," ",posicionA," ",posicionD)
	GlobalSignal.controlMarcaPaso.emit(false) #detiene el paso del juego
	angulo_enfrentamiento(idA,idD,posicionA,posicionD)
	
func _crear_clave(a, b): ## Genera una clave única que ignora el orden
	var clave = _generar_clave(a, b)
	
	if not pares_almacenados.has(clave):
		pares_almacenados[clave] = {"valor1": a,"valor2": b}
		return true  # Se almacenó
	return false  # Ya existía


## Elimina un par específico
func eliminar_par(a: int, b: int) -> bool:
	var clave = _generar_clave(a, b)
	if pares_almacenados.has(clave):
		pares_almacenados.erase(clave)
		return true
	return false
## Cuenta cuántos pares únicos hay
func contar_pares() -> int:
	return pares_almacenados.size()

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
	var giro=rad_to_deg(atan2(dir.y, dir.x))
	
	# Girar las piezas
	GlobalSignal.giro_pieza.emit(idA,posicionD)
	GlobalSignal.giro_pieza.emit(idD,posicionA)
	#print (giro)
