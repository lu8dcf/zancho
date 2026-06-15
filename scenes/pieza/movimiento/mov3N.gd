extends Node
class_name TorreN

var pasos=0 #cantidad dee pasos que dara para cambio de  secuencia 

# Referencia a la pieza base (el RigidBody3D que contiene este componente)
var pieza: PiezaBase
var proxima_posicion : Vector3

# desplazamiento Torre
var direccion= Vector3i(0,0,0)
var secuencia = [0,3,3,3,3,4,4,3,3,4,4]
var paso = 0



func _ready():
	# Obtener la referencia a la pieza base (el owner del componente)
	pieza = get_parent() as PiezaBase
	
	# Verificar que se obtuvo correctamente
	if not pieza:
		print ("El componente Torre debe ser hijo directo de una PiezaBase")
		return

	# Conectar señal después de que la pieza esté lista
	await pieza.ready
	
	await get_tree().create_timer(1).timeout
	
	var posicionActual = calculoPosActual()
	#var limite = GlobalJuego.tamano_tablero.x - 1 #seria una general
	#depende del lado que este del tablero, cambia la secuencia
	if( posicionActual.x+ posicionActual.z<15):
		#lado izquierdo
		secuencia=[0,4,4,3,3]
	elif(posicionActual.x + posicionActual.z>15):
		#lado derecho
		secuencia = [0,3,3,4,4]
	else:
		#diagonal
		secuencia = [0,3,4,3,4]
		

	GlobalSignal.connect("marcaPaso",movimiento	)


	

func calculoPosActual() -> Vector3i:
	var actual = Vector3i(
	round(pieza.global_position.x / GlobalJuego.espaciado_baldosas),
	0,
	round(pieza.global_position.z / GlobalJuego.espaciado_baldosas))
	return actual

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
			
	
