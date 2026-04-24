extends Node3D
class_name GestorHover

@onready var camara3d : Camera3D = $"../Camera3D"

# Variables privadas
var baldosa_actual : BaldosaBase = null
var camara_referencia : Camera3D = null
var gestor_tablero : GestorTablero = null

var ultima_baldosa_clickeada = null

func _ready():
	# Buscar referencias automáticamente
	buscar_referencias()
	
	if Piezas.has_signal("modo_colocacion_inicia"):
		Piezas.modo_colocacion_inicia.connect(_on_modo_colocacion_iniciado)
	if Piezas.has_signal("modo_colocacion_cancelado"):
		Piezas.modo_colocacion_cancelado.connect(_on_modo_colocacion_cancelado)
	

func buscar_referencias():
	# Buscar cámara
	camara_referencia = get_viewport().get_camera_3d()
	if not camara_referencia:
		# Buscar en el árbol si no es la actual
		camara_referencia = get_tree().get_first_node_in_group("camara_principal")
	
	# Buscar gestor de tablero
	gestor_tablero = get_tree().root.find_child("gestorTablero", true, false)
	if not gestor_tablero:
		gestor_tablero = get_tree().root.find_child("GestorTablero", true, false)

func _process(_delta):
	detectar_baldosa_bajo_mouse()

func _input(event):
	if event is InputEventMouseButton:
		_manejar_click_mouse(event)

func _manejar_click_mouse(event: InputEventMouseButton):
	if not event.pressed:
		return
	
	var baldosa = _obtener_baldosa_bajo_mouse()
	if not baldosa:
		return
	
	match event.button_index:
		MOUSE_BUTTON_LEFT:
			_manejar_click_izquierdo(baldosa)
		MOUSE_BUTTON_RIGHT:
			_manejar_click_derecho(baldosa)


# manejo de clicks
func _manejar_click_izquierdo(baldosa: BaldosaBase):
	print("Click izquierdo en baldosa: ", baldosa.obtener_coordenadas())
	
	if Piezas.modo_colocacion:
		# Modo colocación activo
		if baldosa.es_valido_colocar:
			print("Intentando colocar pieza...")
			baldosa._intentar_colocar_pieza()
		else:
			print("Posición no válida para colocar")
	else:
		# Modo normal - seleccionar baldosa
		ultima_baldosa_clickeada = baldosa
		baldosa.baldosa_presionada.emit(baldosa)
		
		# También notificar al GestorTablero si existe
		if gestor_tablero and gestor_tablero.has_method("_en_baldosa_presionada"):
			gestor_tablero._en_baldosa_presionada(baldosa)

func _manejar_click_derecho(baldosa: BaldosaBase):
	print("Click derecho en baldosa: ", baldosa.obtener_coordenadas())
	
	if Piezas.modo_colocacion:
		# Cancelar modo colocación
		print("Cancelando modo colocación")
		Piezas.cancelar_modo_colocacion()
	else:
		# Comportamiento normal de click derecho
		baldosa.baldosa_click_derecho.emit(baldosa)

func detectar_baldosa_bajo_mouse():
	var baldosa_detectada = _obtener_baldosa_bajo_mouse()
	actualizar_hover(baldosa_detectada)

func _obtener_baldosa_bajo_mouse() -> BaldosaBase:
	var posicion_mouse = get_viewport().get_mouse_position()
	var espacio = get_world_3d().direct_space_state
	
	# Configurar rayo
	var origen = camara_referencia.project_ray_origin(posicion_mouse)
	var destino = origen + camara_referencia.project_ray_normal(posicion_mouse) * 1000
	
	var consulta = PhysicsRayQueryParameters3D.create(origen, destino)
	consulta.collide_with_areas = true
	consulta.collide_with_bodies = true  # También detectar StaticBody3D
	consulta.exclude = [camara_referencia]
	
	var resultado = espacio.intersect_ray(consulta)
	
	if not resultado.is_empty():
		var nodo_golpeado = resultado.get("collider")
		if nodo_golpeado:
			return encontrar_baldosa_padre(nodo_golpeado)
	
	return null

func encontrar_baldosa_padre(nodo: Node) -> BaldosaBase:
	var padre = nodo
	var intentos = 0
	var max_intentos = 10
	
	while padre and intentos < max_intentos:
		if padre is BaldosaBase:
			return padre
		padre = padre.get_parent()
		intentos += 1
	
	return null

func actualizar_hover(nueva_baldosa: BaldosaBase):
	# Si es la misma baldosa, no hacer nada
	if nueva_baldosa == baldosa_actual:
		return
	
	# Quitar hover de la anterior
	if baldosa_actual:
		baldosa_actual._al_salir_mouse()
	
	# Actualizar referencia
	baldosa_actual = nueva_baldosa
	
	# Poner hover en la nueva
	if baldosa_actual:
		baldosa_actual._al_entrar_mouse()			


func _on_modo_colocacion_iniciado(tipo_pieza: int, nombre: String):
	if baldosa_actual:
		baldosa_actual._al_entrar_mouse()

func _on_modo_colocacion_cancelado():
	if baldosa_actual:
		baldosa_actual._al_salir_mouse()

# Método público para obtener la baldosa actual
func obtener_baltosa_actual() -> BaldosaBase:
	return baldosa_actual

# Método para limpiar el hover
func limpiar_hover():
	if baldosa_actual:
		baldosa_actual._al_salir_mouse()
		baldosa_actual = null
