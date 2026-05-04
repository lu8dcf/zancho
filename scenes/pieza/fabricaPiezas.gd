extends Node
class_name FabricaPiezas

var nueva_pieza: RigidBody3D
var espaciado_baldosas : float = globalJuego.espaciado_baldosas
var pieza_escena = preload("res://scenes/pieza/pieza_base.tscn")
var velocidad: float = 1.0
var id:int  # id de la pieza
var sitio3d: Vector3i

func _ready() -> void:
	GlobalSignal.connect("crearPieza",colocar_pieza) # Singleton
	
	
func colocar_pieza(sitio: Vector2i, tipo: int , pieza_blanca: bool):
	
	if globalJuego.lugar_disponible(sitio)==false: # verifica que el lugar a instanciar este libre
		return
		
	# instanciar		
	var nueva_pieza = pieza_escena.instantiate()
			
	nueva_pieza.pieza_tipo = tipo
	nueva_pieza.pieza_blanca = pieza_blanca 
	nueva_pieza.pieza_sitio = sitio 
	
	sitio3d = Vector3i(round(sitio.x * espaciado_baldosas), 10,round(sitio.y * espaciado_baldosas))
	
	# Asignar al grupo correspondiente
	if pieza_blanca:
		nueva_pieza.add_to_group("pieza_blanca")
	else:
		nueva_pieza.add_to_group("pieza_negra")
	
	nueva_pieza.id=id	
		
	add_child(nueva_pieza)
	
	nueva_pieza.global_position = sitio3d
		
		
	Piezas.pieza_activa.append(nueva_pieza)
	#print ((Piezas.pieza_activa[id].global_position)/globalJuego.espaciado_baldosas)
	
	#print ("Blanca ",Piezas.contar_piezas_blancas())
	#print ("Negras ",Piezas.contar_piezas_negras())
