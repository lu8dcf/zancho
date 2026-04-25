extends Node
class_name ReyB

var pasos=0 #cantidad dee pasos que dara para cambio de  secuencia 

# Referencia a la pieza base (el RigidBody3D que contiene este componente)
var pieza: PiezaBase
var proxima_posicion : Vector3

# desplazamiento Torre
var direccion= Vector3i(0,0,0)
var secuencia = [0,1,2,3,4]
var paso = 3



func _ready():
	# Obtener la referencia a la pieza base (el owner del componente)
	pieza = get_parent() as PiezaBase
	
	# Verificar que se obtuvo correctamente
	if not pieza:
		print ("El componente Peon debe ser hijo directo de una PiezaBase")
		return

	# Conectar señal después de que la pieza esté lista
	await pieza.ready
	#GlobalSignal.connect("marcaPaso",movimiento	)
	
		
func movimiento():
	
	cambio_estado(paso)
	# actualizacion de posicion
	var cambio = direccion*GlobalJuego.espaciado_baldosas # # vector de cambio de la pieza
	
	# proximo sitio a ocupar
	var sitio3d = round(owner.global_position+cambio)/globalJuego.espaciado_baldosas # en 3d
	# convierto la proxima posicion en 2Di para 
	var nuevo_sitio = Vector2i(sitio3d.x,sitio3d.z)  # en 2d
	
	if globalJuego.verifica_extremos(nuevo_sitio)==false:
		saltar_paso()
		return
	
	if globalJuego.verifica_obstaculos(nuevo_sitio)==false:
		saltar_paso()
		return
		
	if globalJuego.verifica_piezas(nuevo_sitio)==false:
		paso=0
		return
	
	owner.animacion_caminata("Bidle")
	
	var tween = create_tween()
	tween.tween_property(owner, "global_position", owner.global_position + cambio , 1) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN_OUT)
	paso = 3

	
func saltar_paso(): # volver a iniciar en otra posicion d esalto
	paso +=1
	if paso==5: paso=2
	movimiento()  	
	
# Estadod de la pieza
func cambio_estado(cambio):
	
	match secuencia[cambio]:
		0: # Quieto
			direccion = Vector3i(0,0,0)
			owner.giro(45)
		1: # arriba
			direccion = Vector3i(1,0,-1)
			owner.giro(225)
		2:# derecha
			direccion = Vector3i(1,0,1)
			owner.giro(135)
		3: # abajo
			direccion = Vector3i(-1,0,1)
			owner.giro(45)
		4: # izquierda
			direccion = Vector3i(-1,0,-1)
			owner.giro(-45)


	
