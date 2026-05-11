extends Node3D

var pares_almacenados = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignal.connect("ataque",iniciaAtaque)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func iniciaAtaque(idA,idD,posicionA,posicionD):
	print (idA," ",idD," ",posicionA," ",posicionD)
	var clave = _generar_clave(idA, idD)
	
	if not pares_almacenados.has(clave):
		pares_almacenados[clave] = {
			"valor1": a,
			"valor2": b,
			"timestamp": Time.get_unix_time_from_system()
		}
		return true  # Se almacenó
	return false  # Ya existía
	
	
	GlobalSignal.controlMarcaPaso.emit(false)
	pass
	

## Genera una clave única que ignora el orden
func _generar_clave(a: int, b: int) -> String:
	# Ordenamos los números para que (1,2) y (2,1) generen la misma clave
	var menor = min(a, b)
	var mayor = max(a, b)
	return str(menor) + "|" + str(mayor)
