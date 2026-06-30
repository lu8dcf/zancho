extends Node
class_name FabricaPiezas

var nueva_pieza: RigidBody3D
var espaciado_baldosas : float = GlobalJuego.espaciado_baldosas
var pieza_escena = preload("res://scenes/pieza/pieza_base.tscn")


var id:int = 0  # id de la pieza
var sitio3d: Vector3i



func _ready() -> void:
	GlobalSignal.connect("crearPieza",colocar_pieza) # Singleton
	
	
func colocar_pieza(sitio: Vector2i, tipo: int , pieza_blanca: bool):
	
	if GlobalJuego.lugar_disponible(sitio)==false: # verifica que el lugar a instanciar este libre
		return
	if pieza_blanca:	
		if limite_pieza(tipo):  # verifica que no se puedan poner mas piezas		
			return
	# instanciar		
	nueva_pieza = pieza_escena.instantiate()
			
	nueva_pieza.pieza_tipo = tipo
	nueva_pieza.pieza_blanca = pieza_blanca 
	nueva_pieza.pieza_sitio = sitio 
			
	sitio3d = Vector3i(round(sitio.x * espaciado_baldosas), 10,round(sitio.y * espaciado_baldosas))
	
	# Asignar al grupo correspondiente
	if pieza_blanca:
		Piezas.pieza_blanca.append(nueva_pieza)
		
	else:
		Piezas.pieza_negra.append(nueva_pieza)
	
	nueva_pieza.id=id	
		
	add_child(nueva_pieza)
	
	nueva_pieza.global_position = sitio3d
	
	
		
	
	#print ((Piezas.pieza_activa[id].global_position)/GlobalJuego.espaciado_baldosas)
	id += 1 # incrementador de nuemro de pieza
	
	
func limite_pieza(tipo) -> bool:
	var cantidad_a = 0
	var limite = 0
	for pieza in Piezas.pieza_blanca:
		if pieza.pieza_tipo == tipo:
			cantidad_a +=1
	
	match tipo:
		0:
			limite=1
		1:
			limite=8
		2:
			limite=2
		3:
			limite=2
		4:
			limite=2
		5:
			limite=1
	
	if cantidad_a >= limite:
		return true
	return false	
	
				
			
