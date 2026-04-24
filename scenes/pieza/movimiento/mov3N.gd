extends Node
class_name TorreN

var pasos=0 #cantidad dee pasos que dara para cambio de  secuencia 

# Referencia a la pieza base (el RigidBody3D que contiene este componente)
var pieza: PiezaBase
var proxima_posicion : Vector3

# desplazamiento Torre
var direccion= Vector3i(0,0,0)
var secuencia = [0,3,3,2,2,3,3,4,4,3,3,4,4]
var paso = 0



func _ready():
	# Obtener la referencia a la pieza base (el owner del componente)
	pieza = get_parent() as PiezaBase
	
	# Verificar que se obtuvo correctamente
	if not pieza:
		print ("El componente Peon debe ser hijo directo de una PiezaBase")
		return

	# Conectar señal después de que la pieza esté lista
	await pieza.ready
	GlobalSignal.connect("marcaPaso",movimiento	)
	
		
func movimiento():
	dar_paso()
	# actualizacion de posicion
	var cambio = direccion*GlobalJuego.espaciado_baldosas # # vector de cambio de la pieza
	
	if owner.verificar_proximo_paso(cambio)==false:
		saltar_paso()
		return
	
	#owner.animacion_caminata("Bidle")
	
	var tween = create_tween()
	tween.tween_property(owner, "global_position", owner.global_position + cambio , 1) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN_OUT)
	
func dar_paso():
	paso+=1
	if paso==len(secuencia): paso=1
	cambio_estado(paso)
	
func saltar_paso(): # volver a iniciar en otra posicion d esalto
	movimiento()  	
	
# Estadod de la pieza
func cambio_estado(cambio):
	
	match secuencia[cambio]:
		0: # Quieto
			direccion = Vector3i(0,0,0)
			owner.giro(45)
		1: # arriba
			direccion = Vector3i(0,0,-1)
			owner.giro(-90)
		2:# derecha
			direccion = Vector3i(1,0,0)
			owner.giro(179)
		3: # abajo
			direccion = Vector3i(0,0,1)
			owner.giro(90)
		4: # izquierda
			direccion = Vector3i(-1,0,0)
			owner.giro(0)
			
	
