extends Node
class_name PeonN

var pasos=0 #cantidad dee pasos que dara para cambio de  secuencia 

# Referencia a la pieza base (el RigidBody3D que contiene este componente)
var pieza: PiezaBase
var proxima_posicion : Vector3

# desplazamiento Torre
var direccion= Vector3i(0,0,0)
#var secuencia = [0,1,2,3,4]
var secuencia = [3,2,4,1,0]
var paso = 3

# variables para detectar cuando el peon queda trabado y no puede avanzar
var pasos_detenido = 0
var estado_detenido=false
var valor_giro=45	

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
	# observo casilla frontal
	cambio_estado(3) # adelante
	var cambio = direccion * GlobalJuego.espaciado_baldosas
	var sitio3d = round(owner.global_position + cambio) / GlobalJuego.espaciado_baldosas #
	var nuevo_sitio = Vector2i(sitio3d.x, sitio3d.z)#vector 2i con las coordenadas

	if !GlobalJuego.verifica_piezas(nuevo_sitio): # Si adelante hay una pieza, se queda quieto
		pasos_detenido += 1
		estado_detenido=true
		print ("giro")	
		if pasos_detenido >= 3:
			pieza.die()
		return
	
	pasos_detenido = 0 	# Si no esta bloqueado por pieza reiniciamos contador
	if estado_detenido:
		estado_detenido=false
		return
	owner.giro(valor_giro)

	for estado in secuencia: 	# Buscar movimiento segun prioridad
		cambio_estado(estado)
		cambio = direccion * GlobalJuego.espaciado_baldosas
		if owner.verificar_proximo_paso(cambio):
			mover(cambio)
			return
	

func mover(cambio):  # Efecto del cambio desplazamiento

	var tween = create_tween()
	tween.tween_property(owner, "global_position", owner.global_position + cambio , 1) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN_OUT)

	
# Estadod de la pieza
func cambio_estado(cambio):
	
	#match secuencia[cambio]:
	match cambio:
		0: # Quieto
			direccion = Vector3i(0,0,0)
			valor_giro=45
		1: # arriba
			direccion = Vector3i(1,0,-1)
			valor_giro=225
		2:# derecha
			direccion = Vector3i(1,0,1)
			valor_giro=135
		3: # abajo [3,4,2,1,0]
			direccion = Vector3i(-1,0,1)
			valor_giro=45
		4: # izquierda
			direccion = Vector3i(-1,0,-1)
			valor_giro=-45
	
	
	
	
