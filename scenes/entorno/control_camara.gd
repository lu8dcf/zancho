extends CharacterBody3D

@onready var camera_3d: Camera3D = $Camera3D


@export_group("Límites de Movimiento")
@export var limite_y_min: float = 3
@export var limite_y_max: float = 13

@export_group("Límites de Ángulo")
@export var limite_mirar_arriba: float = 85.0 
@export var limite_mirar_abajo: float = -85.0

@export_group("Velocidades")
@export var rapidez_movimiento: float = 20.0
@export var rapidez_vuelo: float = 20.0     
@export var sensibilidad_mouse: float = 0.15
@export var friccion: float = 10.0

@onready var posicion_x: float = -2    
@onready var posicion_y: float = 6
@onready var posicion_z: float = 31
var boton_derecho_presionado: bool = false


@export var zoom_distancia: float = 2.0  
@export var zoom_velocidad: float = 10.0 
var posicion_original_camara: Vector3

func _ready() -> void:
	reiniciar_posicion()


func _input(event: InputEvent) -> void:
	#manejo con mouse
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		boton_derecho_presionado = event.pressed
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if event.pressed else Input.MOUSE_MODE_VISIBLE

	#rotacion si el boton derecho es presionado, tengo que hacerlo con mapa por ahora esta asi
	if event is InputEventMouseMotion and boton_derecho_presionado:
		rotate_y(deg_to_rad(-event.relative.x * sensibilidad_mouse))
		var cambio_v = -event.relative.y * sensibilidad_mouse
		camera_3d.rotation_degrees.x = clamp(camera_3d.rotation_degrees.x + cambio_v, limite_mirar_abajo, limite_mirar_arriba)
		
		
	if event.is_action_pressed("zoom_de_camara"):
		zoom_de_camara()

	#reset de camara
	if event.is_action_pressed("resetear_camara"):
		reiniciar_posicion()

func reiniciar_posicion():
	velocity = Vector3.ZERO 
	global_position = Vector3(posicion_x, posicion_y, posicion_z)
	
	rotation_degrees.y = -45
	
	
	camera_3d.rotation_degrees.x = -30
	
func zoom_de_camara():
	pass
	

func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	

	var direccion = (camera_3d.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	

	var movimiento_vertical = 0.0
	if Input.is_key_pressed(KEY_SPACE):
		movimiento_vertical = rapidez_vuelo

	elif Input.is_key_pressed(KEY_SHIFT):
		movimiento_vertical = -rapidez_vuelo


	if direccion != Vector3.ZERO or movimiento_vertical != 0:
		velocity.x = direccion.x * rapidez_movimiento
		velocity.y = direccion.y * rapidez_movimiento + movimiento_vertical
		velocity.z = direccion.z * rapidez_movimiento
	else:

		velocity.x = move_toward(velocity.x, 0, rapidez_movimiento * friccion * delta)
		velocity.y = move_toward(velocity.y, 0, rapidez_movimiento * friccion * delta)
		velocity.z = move_toward(velocity.z, 0, rapidez_movimiento * friccion * delta)


	move_and_slide()
	

	global_position.y = clamp(global_position.y, limite_y_min, limite_y_max)
	
