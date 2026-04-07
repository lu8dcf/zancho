extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 8
@onready var personaje = $"animal-cat2"

@onready var camera_controller = $Camera_controller

# Offset: la distancia que queremos entre el personaje y la cámara
var camera_offset = Vector3(0, 2, 5)

func _physics_process(delta: float) -> void:
	
	# rotacion de camara der / izq
	if Input.is_action_just_pressed("cam_left"):
		camera_controller.rotate_y(deg_to_rad(-30))
	if Input.is_action_just_pressed("cam_right"):
		camera_controller.rotate_y(deg_to_rad(30))
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var direction = (camera_controller.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# rotacion de cara
	if input_dir != Vector2(0,0): # 
		personaje.rotation_degrees.y = camera_controller.rotation_degrees.y - rad_to_deg(input_dir.angle()) + 90
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	controlarAnimaciones(input_dir)
	
	move_and_slide()
	camera_controller.position = lerp(camera_controller.position, position,0.15)
	
func controlarAnimaciones(input_dir):
	if input_dir:
		personaje.correr()
	else:
		personaje.idle()
		
		
		
		
		
		
		
		
		
		
