extends Node3D
class_name GestorHover

@onready var camara3d : Camera3D = $"../Camera3D"

# Variables privadas
var baldosa_actual : BaldosaBase = null
var camara_referencia : Camera3D = null
var gestor_tablero : GestorTablero = null

func _ready():
	# Buscar referencias automáticamente
	buscar_referencias()
	
	# Verificar que todo esté configurado
	if not camara_referencia:
		push_warning("GestorHover: No se encontró cámara")
	if not gestor_tablero:
		push_warning("GestorHover: No se encontró GestorTablero")
	
	print("GestorHover inicializado correctamente")

func buscar_referencias():
	# Buscar cámara
	camara_referencia = get_viewport().get_camera_3d()
	if not camara_referencia:
		# Buscar en el árbol si no es la actual
		camara_referencia = get_tree().get_first_node_in_group("camara_principal")
	
	# Buscar gestor de tablero
	gestor_tablero = get_tree().get_first_node_in_group("gestor_tablero")
	if not gestor_tablero:
		# Buscar por tipo
		for nodo in get_tree().get_nodes_in_group("gestor_tablero"):
			if nodo is GestorTablero:
				gestor_tablero = nodo
				break

func _process(_delta):
	if not camara_referencia:
		buscar_referencias()
		return
	
	detectar_baltosa_bajo_mouse()

func detectar_baltosa_bajo_mouse():
	var posicion_mouse = get_viewport().get_mouse_position()
	var espacio = get_world_3d().direct_space_state
	
	# Configurar rayo
	var origen = camara_referencia.project_ray_origin(posicion_mouse)
	var destino = origen + camara_referencia.project_ray_normal(posicion_mouse) * 1000
	
	var consulta = PhysicsRayQueryParameters3D.create(origen, destino)
	consulta.collide_with_areas = true
	consulta.collide_with_bodies = false
	# Excluir la cámara y otros objetos no relevantes
	consulta.exclude = [camara_referencia]
	

	var resultado = espacio.intersect_ray(consulta)
	var baldosa_detectada : BaldosaBase = null
	
	if not resultado.is_empty():
		var nodo_golpeado = resultado.get("collider")
		
		if nodo_golpeado and nodo_golpeado is Area3D:
			# Buscar la baldosa padre del Area3D
			baldosa_detectada = encontrar_baltosa_padre(nodo_golpeado)
	
	# Manejar cambios de hover
	actualizar_hover(baldosa_detectada)

func encontrar_baltosa_padre(nodo: Node) -> BaldosaBase:
	var padre = nodo.get_parent()
	var intentos = 0
	var max_intentos = 10  # Evitar bucle infinito
	
	while padre and intentos < max_intentos:
		if padre is BaldosaBase:
			return padre
		padre = padre.get_parent()
		intentos += 1
	
	return null

func actualizar_hover(nueva_baltosa: BaldosaBase):
	# Si es la misma baldosa, no hacer nada
	if nueva_baltosa == baldosa_actual:
		return
	
	# Quitar hover de la anterior
	if baldosa_actual:
		baldosa_actual.resaltar(false)
		#print("Hover OUT: ", baldosa_actual.obtener_coordenadas())
	
	# Actualizar referencia
	baldosa_actual = nueva_baltosa
	
	# Poner hover en la nueva
	if baldosa_actual:
		if not baldosa_actual.esta_ocupada:
			baldosa_actual.resaltar(true)
			#print("Hover IN: ", baldosa_actual.obtener_coordenadas())
			

# Método público para obtener la baldosa actual
func obtener_baltosa_actual() -> BaldosaBase:
	return baldosa_actual

# Método para limpiar el hover
func limpiar_hover():
	if baldosa_actual:
		baldosa_actual.resaltar(false)
		baldosa_actual = null
