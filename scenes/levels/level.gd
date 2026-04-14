extends Node3D

# 1. Precargar la escena (fuera de la función para mejor rendimiento)
var hud_escena = preload("res://scenes/ui/hud.tscn")
var tablero_escena = preload("res://scenes/tablero/gestorTablero.tscn")
var entorno = preload("res://scenes/entorno/escenario.tscn")
var pieza = preload("res://scenes/pieza/pieza_base.tscn")


func _ready() -> void:
	
	var hud = hud_escena.instantiate()
	add_child(hud)

	var tablero = tablero_escena.instantiate()
	add_child(tablero)
	
	var mapa = entorno.instantiate()
	add_child(mapa)
	
	add_child(tablero)
	
	var rey = pieza.instantiate()
	rey.global_position = Vector3(0, 10, 0)
	add_child(rey)
