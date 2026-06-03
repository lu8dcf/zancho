extends Node
class_name AlfilN

var pasos=0 #cantidad dee pasos que dara para cambio de  secuencia 

# Referencia a la pieza base (el RigidBody3D que contiene este componente)
var pieza: PiezaBase
var proxima_posicion : Vector3

#var secuencia = [0,3,3,2,2,3,3,4,4,3,3,4,4]
#var paso = 0
# desplazamiento alfil
var direccion= Vector3i(0,0,0)
#var secuencia = [0,3,3,2,2,3,3,4,4,3,3,4,4]
var secuencia = [#3, # diagonal x2
	5, # diagonal x1
	2, # derecha
	4, # izquierda
	0  # quieto
	]
var PasoEsValido = false

# Referencia al AnimationPlayer
#var animation_player: AnimationPlayer

func _ready():
	# Obtener la referencia a la pieza base (el owner del componente)
	pieza = get_parent() as PiezaBase
	
	# Verificar que se obtuvo correctamente
	if not pieza:
		print ("El componente alfil debe ser hijo directo de una PiezaBase")
		return

	# Conectar señal después de que la pieza esté lista
	await pieza.ready
	GlobalSignal.connect("marcaPaso",movimiento	)
	
	# Obtener referencia al AnimationPlayer desde la pieza base
	#animation_player = pieza.get_animation_player()


	
func movimiento():
		#dar_paso()
	## actualizacion de posicion
	#var cambio = direccion*GlobalJuego.espaciado_baldosas # # vector de cambio de la pieza
	#
	#if owner.verificar_proximo_paso(cambio)==false:
		#saltar_paso()
		#return
	#owner.animacion_caminata("Bidle")
	
	
	for i in range(secuencia.size()): #es un sistema de prioridad
		cambio_estado(secuencia[i]) #siempre muevea delante, si no, una casilla, si no a la derecha y asi
		var cambio = direccion * GlobalJuego.espaciado_baldosas # vector de cambio de la pieza
		if secuencia[i] == 3: #solo para el que avanza dos, debo chequear el intermpedio para no atravesarlo
			var PasoIntermedio = Vector3(-1,0,1) * GlobalJuego.espaciado_baldosas
			PasoEsValido = (
				owner.verificar_proximo_paso(PasoIntermedio)
				and
				owner.verificar_proximo_paso(cambio))
		else:
			PasoEsValido = owner.verificar_proximo_paso(cambio)
		if (PasoEsValido):
			mover(cambio)
			return
	cambio_estado(0)


func mover(cambio):
	var tween = create_tween()
	tween.tween_property(owner, "global_position", owner.global_position + cambio , 1) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN_OUT)
	
#func dar_paso():
	#paso+=1
	#if paso==len(secuencia): paso=1
	#cambio_estado(paso)
	#
#func saltar_paso(): # volver a iniciar en otra posicion d esalto
	#movimiento()  
	
# Estadod de la pieza
func cambio_estado(cambio):
	#match secuencia[cambio]:
	match cambio:
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
			direccion = Vector3i(-2,0,2) #que avance de a dos casillas en la diagonal
			owner.giro(45)
		4: # izquierda
			direccion = Vector3i(-1,0,-1)
			owner.giro(-45)
		5: # abajo SOLO UNA CASILLA
			direccion = Vector3i(-1,0,1) #que avance de a una casillas en la diagonal
			owner.giro(45)
			
	
