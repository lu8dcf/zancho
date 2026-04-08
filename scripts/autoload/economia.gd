extends Node

var esencia_actual : int = 200 # Esencia inicial para la Oleada 1
var limite_piezas = {
	"Peon": 8,
	"Torre": 2,
	"Alfil": 2,
	"Caballo": 2,
	"Reina": 1
}

var inventario_actual = {
	"Peon": 0,
	"Torre": 0,
	"Alfil": 0,
	"Caballo": 0,
	"Reina": 0
}

func puede_comprar(tipo_pieza, costo):
	if esencia_actual >= costo and inventario_actual[tipo_pieza] < limite_piezas[tipo_pieza]:
		return true
	return false

func comprar_pieza(tipo_pieza, costo):
	esencia_actual -= costo
	inventario_actual[tipo_pieza] += 1
	# Emitir señal para actualizar la UI de la tienda
