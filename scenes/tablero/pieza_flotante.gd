extends Node3D
class_name PiezaFlotante


@onready var modelo_3d: Node3D = $Modelo3D

var tipo_pieza :int = 0
var altura_flotante : float = 1.0
var camara: Camera3D
var gestor_tablero: GestorTablero

var baldosa_actual :BaldosaBase = null

func _ready():
	gestor_tablero = get_tree().get_first_node_in_group("gestor_tablero")
	camara = get_viewport().get_camera_3d()

	Piezas.modo_colocacion_inicia.connect(_on_modo_colocacion_iniciado)
	Piezas.modo_colocacion_cancelado.connect(_on_modo_colocacion_cancelado)
	
	visible = false

# funciones de señales
func _on_modo_colocacion_iniciado(tipo: int, nombre: String):
	print("PiezaFlotante: Modo colocación iniciado - Tipo: ", tipo, " Nombre: ", nombre)
	tipo_pieza = tipo
	cargar_escena_pieza(tipo)
	visible = true
	set_process(true)
	
	
		
func _on_modo_colocacion_cancelado():
	visible = false
	set_process(false)
	_limpiar_modelo()

func cargar_escena_pieza(tipo: int):
	_limpiar_modelo()
	var ruta = "res://assets/modelos/piezas/pieza_" + str(tipo) + "B.tscn"
	
	var modelo_objeto = load(ruta)
	if not modelo_objeto:
		print ("No se puede cargar la escena del objeto pieza")
		return
		
	# Instanciar y agregar al contenedor
	var instancia_objeto_pieza = modelo_objeto.instantiate()
	modelo_3d.add_child(instancia_objeto_pieza)
	
	instancia_objeto_pieza.scale = Vector3.ONE * 1.0
	instancia_objeto_pieza.position = Vector3.ZERO
	
func _limpiar_modelo():
	for hijo in modelo_3d.get_children():
		hijo.queue_free()


func _process(delta):
	if not visible or not camara:
		return
	
	var baldosa = _obtener_baldosa()
	if baldosa:
		global_position = baldosa.obtener_punto_colocacion() + Vector3(0, altura_flotante, 0)
		modelo_3d.rotate_y(delta * 2.0)
		baldosa_actual = baldosa
	
func _obtener_baldosa() -> BaldosaBase:
	if not camara or not gestor_tablero:
		return null
	
	var mouse_pos = get_viewport().get_mouse_position()
	var origen = camara.project_ray_origin(mouse_pos)
	var direccion = camara.project_ray_normal(mouse_pos)
	
	# Configurar raycast
	var espacio = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.new()
	query.from = origen
	query.to = origen + direccion * 1000.0
	query.collision_mask = 1  # Asegúrate de que las baldosas estén en capa 1
	query.collide_with_areas = true
	query.collide_with_bodies = true
	
	var resultado = espacio.intersect_ray(query)
	
	if resultado:
		var collider = resultado.collider
		# Buscar la baldosa (puede estar en el Area3D o en el padre)
		if collider is Area3D:
			var padre = collider.get_parent()
			if padre is BaldosaBase:
				return padre
		elif collider is StaticBody3D:
			var padre = collider.get_parent()
			if padre is BaldosaBase:
				return padre
		elif collider is BaldosaBase:
			return collider
	
	return null
	
	
