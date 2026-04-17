extends Node3D


# 1. Precargar la escena (fuera de la función para mejor rendimiento)
var hud_escena = preload("res://scenes/ui/hud.tscn")
var tablero_escena = preload("res://scenes/tablero/gestorTablero.tscn")
var entorno = preload("res://scenes/entorno/escenario.tscn")
var obstaculos_escena = preload("res://scenes/objetos/Objetos.tscn")


var tipo_pieza=0


@onready var MarcaPasos = $MarcaPasos

func _ready() -> void:
	
	var hud = hud_escena.instantiate()
	add_child(hud)

	var tablero = tablero_escena.instantiate()
	add_child(tablero)
	
	var obstaculos = obstaculos_escena.instantiate()
	add_child(obstaculos)
	
	var mapa = entorno.instantiate()
	add_child(mapa)
	
	GlobalSignal.emit_signal("controlMarcaPaso",true)	
	
		
