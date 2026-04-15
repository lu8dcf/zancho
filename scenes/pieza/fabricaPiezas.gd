extends Node

var nueva_pieza: RigidBody3D
var espaciado_baldosas : float = globalJuego.espaciado_baldosas
var pieza = preload("res://scenes/pieza/pieza_base.tscn")
var velocidad: float = 1.0

func _ready() -> void:
	GlobalSignal.connect("crearPieza",colocar_pieza)
	
	
func colocar_pieza(sitio: Vector2i, tipo: int , blanca: bool):
	
	if lugar_disponible(sitio):
		return
		
	match tipo:
		1: # rey
			pass
		2: # peon
			pass
		3: # alfil
			pass
		4: # torre
			pass
		5: # caballlo
			pass
		6: # reina
			pass
	
	# instanciar		
	var pieza = pieza.instantiate()
	
	pieza.pieza_tipo=tipo
	pieza.pieza_blanca=blanca
	
	if blanca: 
		pieza.angulo_frente = 135
	else:
		pieza.angulo_frente = 45	
		
	add_child(pieza)
	pieza.global_position = Vector3(sitio.x * espaciado_baldosas, 10, sitio.y * espaciado_baldosas)
			
	Piezas.piezas_activas.append(nueva_pieza)
	
	
# verificacion que el sitio este vacio para colocar la pieza
func lugar_disponible(sitio: Vector2i):
	return
	# Verificacion de obstaculos en el mapa
	if sitio in mapas.mapa[globalJuego.mapa_actual]:
		globalJuego.mensaje("No se puede insertar sobre un obstaculo")
		return false	
	# verificar si esta ocupado por otra pieza	
	if sitio in mapas.mapa[globalJuego.mapa_actual]:
		globalJuego.mensaje("No se puede insertar sobre un obstaculo")
		return false	
