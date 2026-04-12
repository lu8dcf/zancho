extends Node

var monedas_actual : int = 1200 # Esencia inicial para la Oleada 1
var limite_piezas = {
	"Peon": 8,
	"Torre": 2,
	"Alfil": 2,
	"Caballo": 2,
	"Reina": 1
}
var valor_reventa = {
	"Peon": 80,
	"Torre": 250,
	"Alfil": 150,
	"Caballo": 175,
	"Reina": 600
}

var inventario_actual = [
	{"nombre": "Peon", "cantidad":7,"max":8},
	{"nombre": "Torre", "cantidad":2, "max":2},
	{"nombre": "Alfil",  "cantidad":0, "max":2},
	{"nombre": "Caballo", "cantidad":2, "max":2},
	{"nombre": "Reina", "cantidad":1, "max":1}
]

var piezas_disponibles_tienda: Array = [
	{"nombre": "Peon", "precio": 100},
	{"nombre": "Torre", "precio": 500},
	{"nombre": "Alfil", "precio": 300},
	{"nombre": "Caballo", "precio": 350},
	{"nombre": "Reina", "precio": 1200}
]

# señales para modificar el hud

signal monedas_cambiadas(nuevas_monedas) # Emite el cambio de moneda
signal pieza_comprada(nueva_pieza)  # Emite la pieza comprada
signal inventario_actualizado(inventario) # Emite el inventario actualizado
signal pieza_vendida()

# funciones para modificar
func añadir_monedas(cantidad: int) -> void:
	monedas_actual += cantidad
	emit_signal("monedas_cambiadas", monedas_actual)  # Notificar al HUD que cambió

func comprar_pieza(pieza:Dictionary) -> bool:
	# Verificar si hay suficiente dinero
	if monedas_actual < pieza["precio"]:
		return false
	
	# Buscar la pieza en el inventario
	for i in range(inventario_actual.size()):
		if inventario_actual[i]["nombre"] == pieza["nombre"]:
			# Verificar si no se ha alcanzado el límite
			if inventario_actual[i]["cantidad"] >= inventario_actual[i]["max"]:
				return false
			
			# Realizar la compra
			monedas_actual -= pieza["precio"]
			inventario_actual[i]["cantidad"] += 1
			
			#print("✅ Comprado: ", pieza["nombre"])
			#print("📦 Nuevo inventario: ", inventario_actual[i]["cantidad"], "/", inventario_actual[i]["max"])
			#print("💰 Monedas restantes: ", monedas_actual)
			
			# Emitir señales en orden correcto
			monedas_cambiadas.emit(monedas_actual)
			pieza_comprada.emit(inventario_actual[i])  # Emitir la pieza actualizada
			inventario_actualizado.emit(inventario_actual)
			
			return true
	return false


#func puede_comprar(tipo_pieza, costo):
	#if monedas_actual >= costo and inventario_actual[tipo_pieza] < limite_piezas[tipo_pieza]:
		#return true
	#return false

#func comprar_pieza(tipo_pieza, costo):
	#monedas_actual -= costo
	#inventario_actual[tipo_pieza] += 1
	## Emitir señal para actualizar la UI de la tienda
	#

func vender_pieza(pieza:Dictionary, valor:int):
	for i in range(inventario_actual.size()):
		if inventario_actual[i]["nombre"] == pieza["nombre"]:
			# Realizar la venta
			
			inventario_actual[i]["cantidad"] -= 1
			monedas_actual += valor
			
			# Emitir señales
			monedas_cambiadas.emit(monedas_actual)
			pieza_comprada.emit(inventario_actual[i])  # Reutilizamos esta señal para actualizar UI
			pieza_vendida.emit()
			
