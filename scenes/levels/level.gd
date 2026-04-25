extends Node3D


# 1. Precargar la escena (fuera de la función para mejor rendimiento)
var hud_escena = preload("res://scenes/ui/hud.tscn")
var tablero_escena = preload("res://scenes/tablero/gestorTablero.tscn")
var entorno = preload("res://scenes/entorno/escenario.tscn")
var fabrica_obstaculos_escena = preload("res://scenes/objetos/fabrica_objetos.tscn")
var pieza_flotante = preload("res://scenes/tablero/pieza_flotante.tscn")

var tipo_pieza=0


@onready var MarcaPasos = $MarcaPasos

func _ready() -> void:
	
	var hud = hud_escena.instantiate()
	add_child(hud)

	var tablero = tablero_escena.instantiate()
	add_child(tablero)
	
	var obstaculos = fabrica_obstaculos_escena.instantiate()
	add_child(obstaculos)
	
	var mapa = entorno.instantiate()
	add_child(mapa)
	
	var pieza = pieza_flotante.instantiate()
	add_child(pieza)
	pieza.visible = false

	GlobalSignal.emit_signal("controlMarcaPaso",true)	

	#GlobalSignal.connect("marcaPaso",prueba)
	
	if not globalJuego.mapa_cambiado.is_connected(obstaculos._on_mapa_cambiado):
		globalJuego.mapa_cambiado.connect(obstaculos._on_mapa_cambiado)
