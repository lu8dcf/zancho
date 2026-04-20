extends Node
class_name Alfil

var pasos=0 #cantidad dee pasos que dara para cambio de  secuencia 

# Referencia a la pieza base (el RigidBody3D que contiene este componente)
var pieza: PiezaBase
var proxima_posicion : Vector3

# desplazamiento alfil
# quieto arriba, derecho, abajo, izquierda
#var estados = [Vector3i(0,0,0),Vector3i(1,0,-1),Vector3i(1,0,-1), Vector3i(-1,0,1),Vector3i(1,0,1)]
var direccion= Vector3i(0,0,0)
var secuencia = [0,3,4,3,2,3,2]
var paso =0

func _ready():
	# Obtener la referencia a la pieza base (el owner del componente)
	pieza = get_parent() as PiezaBase
	
	# Verificar que se obtuvo correctamente
	if not pieza:
		print ("El componente Peon debe ser hijo directo de una PiezaBase")
		return

	GlobalSignal.connect("marcaPaso",movimiento	)
	
func movimiento():
	paso+=1
	if paso ==12: paso=1
	if int(paso/2.0) == paso/2.0:   # pasos pares
		cambio_estado(paso/2)
	
		
	
	var cambio = direccion*GlobalJuego.espaciado_baldosas
	var tween = create_tween()
	tween.tween_property(owner, "global_position", owner.global_position + cambio , 1) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN_OUT)
	#print (int(owner.global_position.x/GlobalJuego.espaciado_baldosas))
	

func cambio_estado(cambio):
	
	match secuencia[cambio]:
		0: # Quieto
			direccion = Vector3i(0,0,0)
		1: # arriba
			direccion = Vector3i(1,0,-1)
			owner.giro(225)
		2:# derecha
			direccion = Vector3i(-1,0,-1)
			owner.giro(315)
		3: # abajo
			direccion = Vector3i(-1,0,1)
			owner.giro(45)
		4: # izquierda
			direccion = Vector3i(1,0,1)
			owner.giro(135)
			
	print ("secuencia ",secuencia[cambio])
