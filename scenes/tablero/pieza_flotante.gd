extends Node3D
class_name PiezaFlotante


@onready var modelo_3d: Node3D = $Modelo3D

var tipo_pieza :int = 1
var altura_flotante : float = 0.5
var camara: Camera3D
var gestor_tablero: GestorTablero

var modelos_piezas: Dictionary = {
	0: "res://assets/modelos/piezas/pieza0B.glb",
	1: "res://assets/modelos/piezas/pieza1B.glb",
	2: "res://assets/modelos/piezas/pieza2B.glb",
	3: "res://assets/modelos/piezas/pieza3B.glb",
	4: "res://assets/modelos/piezas/pieza4B.glb",
	5: "res://assets/modelos/piezas/pieza5B.glb"
}

func _ready():
	gestor_tablero = get_tree().get_first_node_in_group("gestor_tablero")
	camara = get_viewport().get_camera_3d()
	
	# Conectar señales
	Piezas.modo_colocacion_inicia.connect(_on_modo_colocacion_iniciado)
	Piezas.modo_colocacion_cancelado.connect(_on_modo_colocacion_cancelado)
	
	visible = false

# funciones de señales
func _on_modo_colocacion_iniciado(tipo: int, nombre: String):
	tipo_pieza = tipo
	cargar_modelo_pieza(tipo)
	visible = true
	set_process(true)

func _on_modo_colocacion_cancelado():
	visible = false
	set_process(false)
	_limpiar_modelo()

func cargar_modelo_pieza(tipo: int):
	_limpiar_modelo()
	var ruta = modelos_piezas.get(tipo, "")

	var modelo_resource = load(ruta)
	if modelo_resource:
		var instancia = modelo_resource.instantiate()
		instancia.name = "ModeloPieza"
		modelo_3d.add_child(instancia)
		instancia.scale = Vector3.ONE * 0.8
	
func _limpiar_modelo():
	for hijo in modelo_3d.get_children():
		hijo.queue_free()


func _process(delta):
	if not visible or not camara:
		return
	
	# Obtener posición del mouse en el mundo 3D
	var posicion_mundo = _obtener_posicion_mouse_3d()
	
	if posicion_mundo != Vector3.ZERO:
		# Posicionar la pieza flotante
		global_position = posicion_mundo + Vector3(0, altura_flotante, 0)
		
		# Rotación suave para mejor visualización
		modelo_3d.rotate_y(delta * 2.0)
		
		
# POSIBLEMENTE SE SACA
func _obtener_posicion_mouse_3d() -> Vector3:
	var mouse_pos = get_viewport().get_mouse_position()
	var origen = camara.project_ray_origin(mouse_pos)
	var direccion = camara.project_ray_normal(mouse_pos)
	
	# Raycast contra el plano del tablero (y = 0)
	var plano = Plane(Vector3.UP, 0)
	var interseccion = plano.intersects_ray(origen, direccion)
	
	if interseccion:
		return origen + direccion * interseccion
	
	return Vector3.ZERO
