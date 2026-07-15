extends Node3D
class_name UbicadorObjetos

@export var  escena_obstaculo : PackedScene # escena base
var altura_objetos :float = 0.2
var espaciado_baldosas :float = GlobalJuego.espaciado_baldosas

var gestor_tablero 

# variables para mapas
var obstaculos_instanciados : Array = [] 
var ultima_oleada_cargada: int = -1
var ultima_clave_mapa: String = ""

func _ready():
	await  get_tree().process_frame # esperar a que el tablero se instancie
	gestor_tablero = get_tree().root.find_child("GestorTablero", true, false)
	cargar_obstaculos()
	if not GlobalSignal.finalizaOleada.is_connected(_on_finaliza_oleada):
		GlobalSignal.finalizaOleada.connect(_on_finaliza_oleada)


func _on_finaliza_oleada(gano:bool) -> void:
	if not gano:
		return
	await get_tree().process_frame
	recargar_mapa()

func cargar_obstaculos():
	limpiar_obstaculos()
	
	if not gestor_tablero:
		push_error("no hay tablero")
		return
		
	var datos_mapa = mapas.obtener_mapa_para_oleada(GlobalJuego.oleada_actual)
	if not datos_mapa.has("posiciones") or not datos_mapa.has("tipos"):
		return
		
	var posiciones = datos_mapa["posiciones"]
	var tipos = datos_mapa["tipos"]
	#print("Cargando obstáculos del mapa ", indice_mapa, " con ", posiciones.size(), " obstáculos")
	
	# crear cada obstaculo
	for i in range(posiciones.size()):
		var posicion_grid:Vector2i = posiciones[i]
		var tipo:int = tipos[i]
		
		if not mapas.tipo_obstaculo.has(tipo):
			continue
		
		var escena_obstaculo: PackedScene = load(mapas.tipo_obstaculo[tipo])
		if not  escena_obstaculo:
			continue
		var obstaculo = escena_obstaculo.instantiate()
		if not obstaculo:
			continue
			
		obstaculo.position = Vector3(posicion_grid.x,altura_objetos,posicion_grid.y)
		
		obstaculo.set_meta("tipo_obstaculo", tipo)
		obstaculo.set_meta("posicion_tablero", posicion_grid)
		obstaculo.set_meta("es_obstaculo", true)

		add_child(obstaculo)
		if obstaculo:
			obstaculos_instanciados.append(obstaculo)
			
			# Opcional: Marcar la baldosa como bloqueada en el tablero
			var baldosa = gestor_tablero.obtener_baldosa_en_coordenadas(obstaculo.position)
			if baldosa and baldosa.has_method("marcar_como_bloqueada"):
				baldosa.marcar_como_bloqueada()

func crear_obstaculo_en_posicion(posicion: Vector2i, tipo_obstaculo: int) -> Node3D:
	var obstaculo : Node3D
	
	# Método 1: Usar escena de obstáculo si está asignada
	
	# Método 2: Crear nodo básico con modelo 3D
	obstaculo = Node3D.new()
	obstaculo.name = "Obstaculo_" + str(tipo_obstaculo) + "_" + str(posicion)
	
	# Cargar modelo desde Mapas
	if mapas.tipo_obstaculo.has(tipo_obstaculo):
		var ruta_modelo = mapas.tipo_obstaculo[tipo_obstaculo]
		var modelo_resource = load(ruta_modelo)
		if modelo_resource:
			var modelo_instance = modelo_resource.instantiate()
			obstaculo.add_child(modelo_instance)
		#print("  ruta modelo: ", ruta_modelo, )

# Posicionar el obstáculo
	obstaculo.position = Vector3(
		posicion.x * espaciado_baldosas,
		altura_objetos,
		posicion.y * espaciado_baldosas
	)

	# Añadir metadata útil
	obstaculo.set_meta("tipo_obstaculo", tipo_obstaculo)
	obstaculo.set_meta("posicion_tablero", posicion)
	obstaculo.set_meta("es_obstaculo", true)

	add_child(obstaculo)
	#print("Obstáculo tipo ", tipo_obstaculo, " creado en posición ", posicion)

	return obstaculo

func recargar_mapa():
	print("cargando mapa")
	var datos_mapa = mapas.obtener_mapa_para_oleada(GlobalJuego.oleada_actual)

	#var clave_mapa := generar_clave_mapa(datos_mapa)
#
	#if clave_mapa == ultima_clave_mapa:
		#return
	cargar_obstaculos()


func es_posicion_ocupada_por_obstaculo(posicion: Vector2i) -> bool:
	var indice_mapa = GlobalJuego.mapa_actual 
	return mapas.es_posicion_bloqueada(posicion, indice_mapa)

func limpiar_obstaculos():
	for obstaculo in obstaculos_instanciados:
		if is_instance_valid(obstaculo):
			obstaculo.queue_free()
	obstaculos_instanciados.clear()
	#print("se limpio")
