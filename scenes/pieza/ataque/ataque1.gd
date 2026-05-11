extends Node

class_name Ataque

# Referencia a la pieza base (el RigidBody3D que contiene este componente)
var pieza_padre: PiezaBase

var espaciado = GlobalJuego.espaciado_baldosas

func _ready():
	# Obtener la referencia a la pieza base (el owner del componente)
	pieza_padre = get_parent() as PiezaBase
	# Verificar que se obtuvo correctamente
	if not pieza_padre:
		print ("El componente Peon debe ser hijo directo de una PiezaBase")
		return

	# Conectar señal después de que la pieza esté lista
	await pieza_padre.ready
	#GlobalSignal.connect("marcaPaso",movimiento	)
	configurar_ataque()
	
	
func limpiar_ataques_existentes():
	for child in owner.area_ataque.get_children():
		if child is CollisionShape3D:
			child.queue_free()
			
# Crea un CollisionShape3D para cada dirección (ataque a 1 casilla)
func configurar_ataque():
		
	for dir in owner.pieza.ataque:
		var posicion_ataque = owner.global_position + dir * espaciado * 0.707
		crear_attack_shape(posicion_ataque)


# Crea un CollisionShape3D y lo posiciona correctamente
func crear_attack_shape(posicion: Vector3):
	#print ("crea collision ", posicion.x," ",posicion.y," ",posicion.z)
	var shape = CollisionShape3D.new()
	var cylinder_shape = CylinderShape3D.new()
	
	# Configurar el cilindro
	# Radio = diámetro / 2 = (0.5 * espaciado) / 2 = 0.25 * espaciado
	cylinder_shape.radius = 0.10 * espaciado  # Diámetro = 0.5 * espaciado
	cylinder_shape.height = espaciado          # Altura = espaciado
		
	shape.shape = cylinder_shape
	shape.global_position = posicion
	
		
	# Agregar un script de detección al área 
	shape.set_script(preload("res://scenes/pieza/ataque/detector_ataque.gd"))
	
	# Asignar metadata para saber quién ataca y desde dónde
	#shape.set_meta("tipo_pieza", tipo_pieza)
	#shape.set_meta("es_blanca", es_blanca)
	#shape.set_meta("origen", global_position)
	
	owner.area_ataque.add_child(shape)
