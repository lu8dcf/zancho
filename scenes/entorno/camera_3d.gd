extends Camera3D

#@export var zoom_distancia: float = 10
#@export var zoom_velocidad: float = 10.0
#var haciendo_zoom: bool = false
#
## Usamos un float para controlar el avance, no un Vector3
#var avance_actual: float = 0.0
#
#func _process(delta: float) -> void:
	## 1. Calculamos cuánto debería estar avanzada la cámara
	#var objetivo_avance = zoom_distancia if haciendo_zoom else 0.0
	#
#
	#avance_actual = lerp(avance_actual, objetivo_avance, zoom_velocidad * delta)
	#
	#position = Vector3.ZERO 
	#translate_object_local(Vector3(0, 0, -avance_actual))
#
#func _input(event: InputEvent) -> void:
	#if event.is_action("zoom_de_camara"):
		#haciendo_zoom = event.is_pressed()
#
#func reset_zoom_instante():
	#haciendo_zoom = false
	#avance_actual = 0.0
	#position = Vector3.ZERO



#extends Camera3D


@export var fov_objetivo: float = 35.0  
@export var fov_velocidad: float = 8.0  
var fov_original: float

var haciendo_zoom: bool = false

func _ready() -> void:
	
	fov_original = fov

	fov = fov_original

func _process(delta: float) -> void:

	var destino = fov_objetivo if haciendo_zoom else fov_original
	
	
	fov = lerp(fov, destino, fov_velocidad * delta)

func _input(event: InputEvent) -> void:
	
	if event.is_action("zoom_de_camara"):
		haciendo_zoom = event.is_pressed()


func reset_zoom_instante():
	haciendo_zoom = false
	fov = fov_original
