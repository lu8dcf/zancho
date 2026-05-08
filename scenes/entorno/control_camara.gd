extends CharacterBody3D

# --- Referencias de Nodos ---
@onready var camera_3d: Camera3D = $Camera3D

# --- Variables Editables ---
@export_group("Límites de Movimiento")
@export var limite_y_min: float = 3
@export var limite_y_max: float = 13

@export_group("Límites de Ángulo")
@export var limite_mirar_arriba: float = 85.0 # Casi vertical
@export var limite_mirar_abajo: float = -85.0

@export_group("Velocidades")
@export var rapidez_movimiento: float = 20.0
@export var rapidez_vuelo: float = 20.0      # Velocidad al presionar Espacio
@export var sensibilidad_mouse: float = 0.15
@export var friccion: float = 10.0

# --- Variables de Estado ---
var boton_derecho_presionado: bool = false

func _input(event) -> void:
	# 1. Rotación activada solo con el BOTÓN DERECHO
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			boton_derecho_presionado = event.pressed
			
			# Captura el mouse para rotación infinita
			if event.pressed:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			else:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	# 2. Lógica de rotación (Horizontal y Vertical)
	if event is InputEventMouseMotion and boton_derecho_presionado:
		# Rotación Horizontal (Eje Y) - Gira el cuerpo
		rotate_y(deg_to_rad(-event.relative.x * sensibilidad_mouse))
		
		# Rotación Vertical (Eje X) - Gira la cámara
		var cambio_v = -event.relative.y * sensibilidad_mouse
		camera_3d.rotation_degrees.x = clamp(camera_3d.rotation_degrees.x + cambio_v, limite_mirar_abajo, limite_mirar_arriba)

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
	
func reiniciar_posicion():
	pass
	
