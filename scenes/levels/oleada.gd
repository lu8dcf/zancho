extends Node3D


# este archivo muestra como crear las piezas en el tablero
func _ready() -> void:
	# paramtros 
	# Sitio Vector2 (x,z) el 0,0 esta en el extremo izq  el 15,15 esta en el extremo derecho
	# Tipo  0-Rey  1-Peon  2-Alfil  3-Torre  4-Caballo  5- Reina
	# Blanca  true piezas blancas   -  False Piezas negras
	
	GlobalSignal.emit_signal("crearPieza",Vector2i(1,14),0,true) #rey blanco en posicion
	
	GlobalSignal.emit_signal("crearPieza",Vector2i(2,6),1,true) #peon blanco en posicion
	GlobalSignal.emit_signal("crearPieza",Vector2i(3,9),2,true) #rey blanco en posicion
	GlobalSignal.emit_signal("crearPieza",Vector2i(4,13),3,true) #torre blanco en posicion
	GlobalSignal.emit_signal("crearPieza",Vector2i(7,10),4,true) #caballo blanco en posicion
	GlobalSignal.emit_signal("crearPieza",Vector2i(8,12),5,true) #reina blanco en posicion
