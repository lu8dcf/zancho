extends Node3D

var pausarOleada :bool = false
var estadoOleada :bool = false
var DATA_OLEADAS = preload("res://scenes/levels/data_oleada.gd").new()
var nivel : int

# este archivo muestra como crear las piezas en el tablero
func _ready() -> void:
	# paramtros 
	# Sitio Vector2 (x,z) el 0,0 esta en el extremo izq  el 15,15 esta en el extremo derecho
	# Tipo  0-Rey  1-Peon  2-Alfil  3-Torre  4-Caballo  5- Reina
	# Blanca  true piezas blancas   -  False Piezas negras

	#GlobalSignal.emit_signal("crearPieza",Vector2i(10,3),1,false) #peon NEGRO en posicion
	#GlobalSignal.emit_signal("crearPieza",Vector2i(11,4),2,false) #alfil NEGRO en posicion
	#GlobalSignal.emit_signal("crearPieza",Vector2i(14,5),3,false) #alfil NEGRO en posicion
	#GlobalSignal.emit_signal("crearPieza",Vector2i(12,6),4,false) #alfil NEGRO en posicion
	#GlobalSignal.emit_signal("crearPieza",Vector2i(12,3),5,false) #alfil NEGRO en posicion
	#
	GlobalSignal.comienzoOleada.connect(ejecuto_oleada)
	#
	#GlobalSignal.emit_signal("crearPieza",Vector2i(5,6),1,true) #peon blanco en posicion
	#GlobalSignal.emit_signal("crearPieza",Vector2i(3,9),2,true) #alfil blanco en posicion
	#GlobalSignal.emit_signal("crearPieza",Vector2i(4,13),3,true) #torre blanco en posicion
	#GlobalSignal.emit_signal("crearPieza",Vector2i(9,10),4,true) #caballo blanco en posicion
	GlobalSignal.emit_signal("crearPieza",Vector2i(9,13),5,true) #reina blanco en posicion
	#GlobalSignal.emit_signal("crearPieza",Vector2i(1,14),0,true) #rey blanco en posicion
	#GlobalSignal.emit_signal("crearPieza",Vector2i(2,9),1,true) #rey blanco en posicion
	#globalJuego.oleada_cambiada.connect(ejecuto_oleada,get_oleada_actual())
	
	#TESTEO
	await get_tree().create_timer(2).timeout
	GlobalSignal.emit_signal("comienzoOleada")
	
	
	#if !(pausarOleada):
		#ejecuto_oleada(globalJuego.oleada_actual)

func get_oleada_actual():
	return globalJuego.oleada_actual
	
	
#	GlobalJuego.espaciado_baldosas
	
func ejecuto_oleada():
	nivel = get_oleada_actual()
	if !DATA_OLEADAS.estructura_por_nivel.has(nivel):
		print("Este nivel aun no esta desarrollado: ", nivel)
		return
	if estadoOleada:# que no se ejecute una oleada dentro de oleada
		return
	estadoOleada = true
	for pieza in DATA_OLEADAS.estructura_por_nivel[nivel]:
		await get_tree().create_timer(.1).timeout
		GlobalSignal.emit_signal("crearPieza",pieza["pos"],pieza["tipo"], pieza["blancas"])
	await get_tree().create_timer(2).timeout #tiempo en que se acomodan las piezas
	Sonidos.comienzoOleada()
	GlobalSignal.emit_signal("controlMarcaPaso",true) #inicio tiempo oleada

	estadoOleada = false
	
	
func detenerOleada():
	pausarOleada =true
	GlobalSignal.emit_signal("controlMarcaPaso",false) # lo cambie ppara que se muevan
	
