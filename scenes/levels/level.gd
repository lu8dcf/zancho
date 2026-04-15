extends Node3D

# 1. Precargar la escena (fuera de la función para mejor rendimiento)
var hud_escena = preload("res://scenes/ui/hud.tscn")
var tablero_escena = preload("res://scenes/tablero/gestorTablero.tscn")
var entorno = preload("res://scenes/entorno/escenario.tscn")

var contador_externo = 0
var contador_interno = 0
@onready var timer = $Timer

func _ready() -> void:
	
	var hud = hud_escena.instantiate()
	add_child(hud)

	var tablero = tablero_escena.instantiate()
	add_child(tablero)
	
	var mapa = entorno.instantiate()
	add_child(mapa)
	
	add_child(tablero)
		
	
	#temporizador
	timer.wait_time = 1.0   # 1 segundo
	timer.connect("timeout",prueba)
	timer.start()
	
func prueba():
	
		# Incrementa el contador interno
	contador_interno += 1
	
	# Si llega a 16, reinicia y avanza el externo
	if contador_interno > 15:
		contador_interno = 0
		contador_externo += 1
		
		# Si el externo también llega a 16, reinicia
		if contador_externo > 15:
			contador_externo = 0
	
		# Crear pieza de prueba esto se debe ejecutar en la oleadas
	GlobalSignal.emit_signal("crearPieza",Vector2i(contador_externo,contador_interno),1,true)
