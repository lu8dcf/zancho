extends Node
class_name PeonN

var pasos=0 #cantidad dee pasos que dara para cambio de  secuencia 

# Referencia a la pieza base (el RigidBody3D que contiene este componente)
var pieza: PiezaBase
var proxima_posicion : Vector3

# desplazamiento Torre
var direccion= Vector3i(0,0,0)
#var secuencia = [0,1,2,3,4]
var secuencia = [3,2,4,0]
var paso = 3
var cambio := Vector3.ZERO

# variables para detectar cuando el peon queda trabado y no puede avanzar
var pasos_detenido = 0
var estado_detenido=false
var valor_giro=45	
#var elegiProximoPaso = false

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
	GlobalSignal.connect("listoParaMover", mover)


func mover():  # Efecto del cambio desplazamiento

	var tween = create_tween()
	tween.tween_property(owner, "global_position", owner.global_position + cambio , 1) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN_OUT)

func movimientoPorOrden():
	cambio_estado(3)
	cambio = direccion * GlobalJuego.espaciado_baldosas
	var adelante = obtengoPosSiguienteGlobal(cambio)
	if GestorMovimiento.verifico_soloPiezas(adelante) or !GestorMovimiento.verifica_extremos(adelante):
		pasos_detenido += 1
		cambio_estado(0)
		cambio = direccion * GlobalJuego.espaciado_baldosas
		if pasos_detenido >= 3:
			pieza.die()
			return
		return
	pasos_detenido = 0
	if estado_detenido:
		estado_detenido = false
	owner.proximoElegido(false)
	for estado in secuencia:
		cambio_estado(estado)
		cambio = direccion * GlobalJuego.espaciado_baldosas
		var siguiente = obtengoPosSiguienteGlobal(cambio)
		if !GestorMovimiento.verifico_proximo(siguiente):
			#print("Casilla no ocupada")
		# Si la casilla está libre y es válida
			owner.giro(valor_giro)
			GestorMovimiento.ocupar_casilla(siguiente)
			GlobalSignal.emit_signal("decision_terminada", true)
			return
			
func obtengoPosSiguienteGlobal(siguientePos):
	return (round(owner.global_position + siguientePos)/GlobalJuego.espaciado_baldosas)

func obtengoPosActual():
	return(round(owner.global_position)/GlobalJuego.espaciado_baldosas)

func calculoPosActual() -> Vector3i:
	return Vector3i(
		round(pieza.global_position.x / GlobalJuego.espaciado_baldosas),
		0,
		round(pieza.global_position.z / GlobalJuego.espaciado_baldosas)
	)
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
