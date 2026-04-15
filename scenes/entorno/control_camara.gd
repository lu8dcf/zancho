extends Node3D
# https://www.youtube.com/watch?v=pdQMd6_dk0E
# tutorial
@onready var pivot_y: Node3D = $PivotY
@onready var pivot_x: Node3D = $PivotY/PivotX
@onready var camera_3d: Camera3D = $PivotY/PivotX/Camera3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

var boton_mouse_rueda_presionada : bool
var rapidez_rotacion :float  = 0.5 

var max_distancia : float = 20.0 
var min_distancia : float = 2.0 
var rapidez_zoom = 0.3

var direccion_movimiento
var rapidez_movimiento : float = 15.0
func _ready() -> void:
	#suave
	pivot_y.top_level = true
	
func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT: # girar camara
			boton_mouse_rueda_presionada = event.pressed 
		if event.button_index == MOUSE_BUTTON_WHEEL_UP: # zoom in y zoom out
			camera_3d.position.z -= rapidez_zoom
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera_3d.position.z += rapidez_zoom
		camera_3d.position.z = clamp(camera_3d.position.z, min_distancia,max_distancia)
	if event is InputEventMouseMotion:
		if boton_mouse_rueda_presionada:
			pivot_y.rotation_degrees.y -= event.relative.x * rapidez_rotacion # se puede poner + para que gire al reves
			pivot_x.rotation_degrees.x -= event.relative.y * rapidez_rotacion
			pivot_x.rotation_degrees.x = clamp(pivot_x.rotation_degrees.x,-80,10)
			
func _physics_process(delta: float) -> void:
	direccion_movimiento = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	global_position += Vector3(direccion_movimiento.x,0,direccion_movimiento.y).rotated(Vector3.UP, pivot_y.rotation.y) * rapidez_movimiento * delta
	pivot_y.global_position = (global_position + pivot_y.global_position) * 0.1
