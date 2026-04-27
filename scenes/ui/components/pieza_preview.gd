# PiezaPreview.gd
extends Node3D
class_name PiezaPreview

@export var velocidad_rotacion: float = 30.0
@export var altura_camara: float = 2.0
@export var distancia_camara: float = 3.0

var modelo_actual: Node3D = null
var camara: Camera3D
var tipo_pieza: int = 0

# Rutas de modelos según tipo
var rutas_modelos: Dictionary = {
	1: "res://assets/modelos/piezas/pieza_1B.tscn",     # Peón
	2: "res://assets/modelos/piezas/pieza_2B.tscn",    # Alfil
	3: "res://assets/modelos/piezas/pieza_3B.tscn",    # Torre
	4: "res://assets/modelos/piezas/pieza_4B.tscn",  # Caballo
	5: "res://assets/modelos/piezas/pieza_5B.tscn"     # Reina
}

func _ready():
	_setup_camara()
	_setup_iluminacion()

func _setup_camara():
	camara = Camera3D.new()
	camara.name = "PreviewCamera"
	camara.current = false
	camara.projection = Camera3D.PROJECTION_PERSPECTIVE
	camara.fov = 45
	add_child(camara)
	
	# Posicionar cámara
	actualizar_posicion_camara()

func _setup_iluminacion():
	# Luz direccional principal
	var luz_direccional = DirectionalLight3D.new()
	luz_direccional.name = "PreviewLight"
	luz_direccional.light_energy = 2.0
	luz_direccional.position = Vector3(2, 4, 2)
	luz_direccional.look_at(Vector3.ZERO)
	add_child(luz_direccional)
	
	# Luz ambiental para rellenar sombras
	var luz_ambiental = DirectionalLight3D.new()
	luz_ambiental.name = "FillLight"
	luz_ambiental.light_energy = 0.5
	luz_ambiental.position = Vector3(-2, 2, -2)
	luz_ambiental.look_at(Vector3.ZERO)
	add_child(luz_ambiental)

func actualizar_posicion_camara():
	if camara:
		var angulo = deg_to_rad(25)  # Ángulo elevado
		camara.position = Vector3(
			distancia_camara * cos(angulo),
			altura_camara,
			distancia_camara * sin(angulo)
		)
		camara.look_at(Vector3(0, 0.5, 0))

func cargar_modelo(tipo: int):
	tipo_pieza = tipo
	
	# Limpiar modelo anterior
	if modelo_actual:
		modelo_actual.queue_free()
		modelo_actual = null
	
	var ruta = rutas_modelos.get(tipo, "")
	if ruta.is_empty():
		_crear_modelo_fallback(tipo)
		return
	
	var recurso = load(ruta)
	if recurso:
		modelo_actual = recurso.instantiate()
		modelo_actual.name = "ModeloPieza"
		add_child(modelo_actual)
		
		# Ajustar escala
		modelo_actual.scale = Vector3.ONE * 0.8
		
		# Centrar el modelo
		modelo_actual.position = Vector3(0, 0.3, 0)
	else:
		_crear_modelo_fallback(tipo)

func _crear_modelo_fallback(tipo: int):
	modelo_actual = Node3D.new()
	modelo_actual.name = "ModeloFallback"
	
	var mesh = MeshInstance3D.new()
	var cilindro = CylinderMesh.new()
	cilindro.top_radius = 0.3
	cilindro.bottom_radius = 0.3
	cilindro.height = 0.6
	mesh.mesh = cilindro
	mesh.position = Vector3(0, 0.3, 0)
	
	var material = StandardMaterial3D.new()
	var colores = [Color.YELLOW, Color.WHITE, Color.CYAN, Color.RED, Color.GREEN, Color.PURPLE]
	material.albedo_color = colores[tipo] if tipo < colores.size() else Color.WHITE
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mesh.material_override = material
	
	modelo_actual.add_child(mesh)
	add_child(modelo_actual)

func _process(delta):
	if modelo_actual:
		modelo_actual.rotate_y(deg_to_rad(velocidad_rotacion) * delta)

func obtener_camara() -> Camera3D:
	return camara
