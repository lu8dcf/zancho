extends Node
class_name Caballo

var pasos=0 #cantidad dee pasos que dara para cambio de  secuencia 

# Referencia a la pieza base (el RigidBody3D que contiene este componente)
var pieza: PiezaBase
var proxima_posicion : Vector3

# desplazamiento Caballo
var direccion= Vector3i(0,0,0)
var secuencia = [0,3,4,5,6,7,8,4,6]
var paso = 0

# Referencia al AnimationPlayer
var animation_player: AnimationPlayer

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
	
	# Obtener referencia al AnimationPlayer desde la pieza base
	animation_player = pieza.get_animation_player()

	
func movimiento():
	if paso == 8:
		paso=0
	if animation_player:
		if animation_player.has_animation("ataque_rey"):
			animation_player.play("ataque_rey")
	
	paso+=1
	cambio_estado(paso)
		
	var cambio = direccion*GlobalJuego.espaciado_baldosas
	var tween = create_tween()
	tween.tween_property(owner, "global_position", owner.global_position + cambio , 1) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN_OUT)
	
# Estadod de la pieza
func cambio_estado(cambio):
	
	match secuencia[cambio]:
		0: # Quieto
			direccion = Vector3i(0,0,0)
			owner.giro(45)
		1: # arriba 1
			direccion = Vector3i(1,0,-2)
			owner.giro(225)
		2:# arriba 2
			direccion = Vector3i(2,0,-1)
			owner.giro(225)
		3: # derecha 1
			direccion = Vector3i(1,0,2)
			owner.giro(135)
		4: # derecha 2
			direccion = Vector3i(2,0,1)
			owner.giro(135)
		5: # abajo 1
			direccion = Vector3i(-2,0,1)
			owner.giro(45)
		6:# adelante 2
			direccion = Vector3i(-1,0,2)
			owner.giro(45)
		7: # izquierda 1
			direccion = Vector3i(-2,0,-1)
			owner.giro(-90)
		8: # izquierda 2
			direccion = Vector3i(-1,0,-2)
			owner.giro(-90)
