extends Node
class_name FabricaPiezas

var nueva_pieza: RigidBody3D
var espaciado_baldosas : float = globalJuego.espaciado_baldosas
var pieza = preload("res://scenes/pieza/pieza_base.tscn")
var velocidad: float = 1.0
var id:int  # id de la pieza

func _ready() -> void:
	GlobalSignal.connect("crearPieza",colocar_pieza) # Singleton
	
	
func colocar_pieza(sitio: Vector2i, tipo: int , pieza_blanca: bool):
	
	if globalJuego.lugar_disponible(sitio)==false: # verifica que el lugar a instanciar este libre
		return
		
	# instanciar		
	var pieza = pieza.instantiate()
	
		
	pieza.pieza_tipo=tipo
	pieza.pieza_blanca=pieza_blanca 
	
	if pieza_blanca: 
		pieza.angulo_frente = 225
	else:
		pieza.angulo_frente = 45	
	
	# agregara datos de piezas
	if pieza_blanca:
		id=Piezas.pieza_b_id  # tomo el id actual
		Piezas.pieza_b_id +=1 # id de la proxima pieza
		# guardo la ubicacion
		Piezas.pieza_b_sitio.insert(id,sitio)
		Piezas.pieza_b_tipo.insert(id,tipo)
		
	else:
		id=Piezas.pieza_n_id  # tomo el id actual
		Piezas.pieza_n_id +=1 # id de la proxima pieza
		# guardo la ubicacion
		Piezas.pieza_n_sitio.insert(id,sitio)
		Piezas.pieza_n_tipo.insert(id,tipo)
		
		
		
	add_child(pieza)
	pieza.global_position = Vector3(sitio.x * espaciado_baldosas, 10, sitio.y * espaciado_baldosas)
		
		
	Piezas.piezas_activas.append(pieza)
	
	
