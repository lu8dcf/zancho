extends CollisionShape3D

@onready var pieza_base = get_node("../..") 
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
	if body.pieza_blanca: 
		if pieza_base.pieza_blanca:
			return
	
	if body.pieza_blanca==false: 
		if pieza_base.pieza_blanca==false:
			return
				
	GlobalSignal.ataque.emit(pieza_base.id,body.id,pieza_base.position,body.position,pieza_base.pieza_tipo,body.pieza_tipo)
	#print("⚔️ Ataque"," yo ",pieza_base.pieza_tipo," ",pieza_base.id," ata ",body.id," ", round(body.position/pieza_base.espaciado))
		#pieza.recibir_ataque(atacante_tipo, get_meta("origen"))
