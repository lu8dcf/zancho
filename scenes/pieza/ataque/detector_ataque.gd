extends CollisionShape3D

# Esta función se llama cuando algo entra en esta área
func _ready():
	# Asegurar que el área padre pueda detectar colisiones
	var parent_area = get_parent()
	if parent_area is Area3D:
		parent_area.body_entered.connect(_on_body_entered)
		#parent_area.area_entered.connect(_on_area_entered)

func _on_body_entered(body: Node):
	if body is PiezaBase:
		manejar_ataque(body)

func _on_area_entered(area: Area3D):
	var pieza = area.get_parent()
	if pieza is PiezaBase:
		manejar_ataque(pieza)

func manejar_ataque(body):
	# Verificar que sea del equipo contrario
	var atacante_blanca = body.pieza_blanca
	var atacante_tipo = body.pieza_tipo
	
	if body.pieza_blanca == true:
		
		print("⚔️ Ataque detectado!"," blanca ",atacante_blanca," tipo ",atacante_tipo)
		#pieza.recibir_ataque(atacante_tipo, get_meta("origen"))
