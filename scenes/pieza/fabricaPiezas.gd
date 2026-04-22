extends Node
class_name FabricaPiezas

var nueva_pieza: RigidBody3D
var espaciado_baldosas : float = globalJuego.espaciado_baldosas
var pieza = preload("res://scenes/pieza/pieza_base.tscn")
var velocidad: float = 1.0

func _ready() -> void:
	GlobalSignal.connect("crearPieza",colocar_pieza)  # Señal que activa la fabricacion e instancia de pieza
	
	
func colocar_pieza(sitio: Vector2i, tipo: int , pieza_blanca: bool):
	
	if lugar_disponible(sitio)==false:
		return
		
		
	# instanciar		
	var pieza = pieza.instantiate()
		
	# Seleccion del script especifico
	var script_especifico = load("res://scenes/pieza/movimiento/mov1N.gd")
	
	#pieza.set_script(script_especifico)
	#add_child(movimiento)
	pieza.pieza_tipo=tipo
	pieza.pieza_blanca=pieza_blanca 
	
	if pieza_blanca: 
		pieza.angulo_frente = 225
	else:
		pieza.angulo_frente = 45	
		
	add_child(pieza)
	pieza.global_position = Vector3(sitio.x * espaciado_baldosas, 10, sitio.y * espaciado_baldosas)
			
	Piezas.piezas_activas.append(pieza)
	
	
# verificacion que el sitio este vacio psra colocar la pieza
func lugar_disponible(sitio: Vector2i):
	
	# Verificacion de obstaculos en el mapa
	if sitio in mapas.mapas[globalJuego.mapa_actual]:
		globalJuego.mensaje("No se puede insertar sobre un obstaculo")
		return false	
	# verificar si esta ocupado por otra pieza	
	return
	if sitio in mapas.mapa[globalJuego.mapa_actual]:
		globalJuego.mensaje("No se puede insertar sobre un obstaculo")
		return false	
