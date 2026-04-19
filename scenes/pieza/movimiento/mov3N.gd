extends Node
class_name Torre

# Referencia a la pieza base (el RigidBody3D que contiene este componente)
var pieza: PiezaBase
var proxima_posicion : Vector3

func _ready():
	# Obtener la referencia a la pieza base (el owner del componente)
	pieza = get_parent() as PiezaBase
	
	# Verificar que se obtuvo correctamente
	if not pieza:
		print ("El componente Peon debe ser hijo directo de una PiezaBase")
		return

	GlobalSignal.connect("marcaPaso",movimiento)
	
func movimiento():
	# peon
	var cambio = Vector3(0,0,1)*GlobalJuego.espaciado_baldosas
	var tween = create_tween()
	tween.tween_property(owner, "global_position", owner.global_position + cambio , 1) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN_OUT)
	#print (int(owner.global_position.x/GlobalJuego.espaciado_baldosas))
	


	
