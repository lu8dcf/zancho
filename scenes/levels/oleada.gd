extends Node3D

var pausarOleada :bool = false
var estadoOleada :bool = false
var DATA_OLEADAS = preload("res://scenes/levels/data_oleada.gd").new()

# este archivo muestra como crear las piezas en el tablero
func _ready() -> void:
	# paramtros 
	# Sitio Vector2 (x,z) el 0,0 esta en el extremo izq  el 15,15 esta en el extremo derecho
	# Tipo  0-Rey  1-Peon  2-Alfil  3-Torre  4-Caballo  5- Reina
	# Blanca  true piezas blancas   -  False Piezas negras
	GlobalSignal.emit_signal("crearPieza",Vector2i(1,14),0,true) #rey blanco en posicion
	globalJuego.oleada_cambiada.connect(ejecuto_oleada,get_oleada_actual())
	#globalJuego.siguiente_oleada() #Testeo de conexion, funciona.

	#GlobalSignal.marcaPaso.connect(_testeo_oleada)
	#if !(pausarOleada):
		#ejecuto_oleada(globalJuego.oleada_actual)

func get_oleada_actual():
	return globalJuego.oleada_actual
	
func ejecuto_oleada(nivel):
	if !DATA_OLEADAS.estructura_por_nivel.has(nivel):
		print("Ese nivel no esta desarrollado.")
		return
	#GlobalSignal.emit_signal("controlMarcaPaso",true) #tiempo!
	if estadoOleada:# que no se ejecute una oleada dentro de oleada
		return
	estadoOleada = true
	for pieza in DATA_OLEADAS.estructura_por_nivel[nivel]:
		GlobalSignal.emit_signal("crearPieza",pieza["pos"],pieza["tipo"], pieza["blancas"])
	estadoOleada = false
	
	
func detenerOleada():
	pausarOleada =true
	GlobalSignal.emit_signal("controlMarcaPaso",false)
	
