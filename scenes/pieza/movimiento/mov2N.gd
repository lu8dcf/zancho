extends Node
class_name Alfil

var pasos=0 #cantidad dee pasos que dara para cambio de  secuencia 

# Referencia a la pieza base (el RigidBody3D que contiene este componente)
var pieza: PiezaBase
var proxima_posicion : Vector3


# desplazamiento alfil
var direccion= Vector3i(0,0,0)
var secuencia = [0,3,2,3,4,3,4]
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
	
	dar_paso()
	
	# actualizacion de posicion
	var cambio = direccion*GlobalJuego.espaciado_baldosas # # vector de cambio de la pieza
	
	verificar_proximo_paso(cambio)
	
	# consulto si esta ocupado
	globalJuego.lugar_disponible(owner.sitio2d)
	
	animacion_caminata()
	
	var tween = create_tween()
	tween.tween_property(owner, "global_position", owner.global_position + cambio , 1) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN_OUT)
	owner.sitio3d=owner.global_position

func verificar_proximo_paso(cambio):
	# proximo sitio a ocupar
	var sitio3d = round(owner.global_position+cambio)/globalJuego.espaciado_baldosas # en 3d
	# convierto la proxima posicion en 2Di para 
	owner.sitio = Vector2i(sitio3d.x,sitio3d.z)  # en 2d
	if globalJuego.lugar_disponible(owner.sitio2d)==false:
		dar_paso()
	
	print (round(owner.sitio2d))

func dar_paso():
	paso+=1
	if paso ==12: paso=1
	if int(paso/2.0) == paso/2.0:   # pasos pares
		cambio_estado(paso/2)
	
func animacion_caminata():
	if animation_player:
		if animation_player.has_animation("ataque_rey"):
			animation_player.play("ataque_rey")
		
	
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
			
	
