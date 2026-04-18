extends Node3D
class_name ObjetoBase

# propiedades
var tipo_objeto: int = 0
var posicion_tablero: Vector2i = Vector2i.ZERO
var es_bloqueante: bool = true

var modelo_3d: Node3D

func inicializar(tipo: int, pos: Vector2i, ruta_modelo: String = "") -> void:
	tipo_objeto = tipo
	posicion_tablero = pos
	
	# Guardar metadata
	set_meta("tipo_objeto", tipo_objeto)
	set_meta("posicion_tablero", posicion_tablero)
	set_meta("es_obstaculo", es_bloqueante)
	
	if not ruta_modelo.is_empty(): # cargar el modelo si existe
		cargar_modelo(ruta_modelo)

func cargar_modelo(ruta: String) -> void: # ruta del modelo
	var modelo_resource = load(ruta)
	if modelo_resource:
		modelo_3d = modelo_resource.instantiate()
		add_child(modelo_3d)
	else:
		push_error("No se pudo cargar el modelo: ", ruta)


func obtener_posicion_3d(espaciado: float, altura: float) -> Vector3:
	return Vector3(
		posicion_tablero.x * espaciado,
		altura,
		posicion_tablero.y * espaciado
	)

func colocar_en_tablero(espaciado: float, altura: float) -> void:
	position = obtener_posicion_3d(espaciado, altura)
