# FabricaObjetos.gd
extends Node3D
class_name FabricaObjetos


var gestor_tablero: GestorTablero
var espaciado_baldosas: float = globalJuego.espaciado_baldosas
var altura_objetos: float = 0.2

var objetos_instanciados: Array[ObjetoBase] = [] # objetos ( obstaculos intanciados)

func _ready():
	await get_tree().process_frame # espera a que cargue el tablero
	gestor_tablero = get_tree().root.find_child("GestorTablero", true, false)
	
	if not globalJuego.mapa_cambiado.is_connected(_on_mapa_cambiado):
		globalJuego.mapa_cambiado.connect(_on_mapa_cambiado)
		
		
	cargar_objetos_del_mapa()

# METODOS DE LA FABRICA
func crear_objeto(tipo: int, posicion: Vector2i) -> ObjetoBase:
	
	var datos_objeto = _obtener_datos_objeto(tipo) # se obtienen todos los meta datos
	
	var objeto = ObjetoBase.new() # crear intancia de objeto
	objeto.name = "Objeto_" + datos_objeto.nombre + "_" + str(posicion)
	
	objeto.inicializar(tipo, posicion, datos_objeto.ruta_modelo) # inicializar el objeto en la posicion indicada
	objeto.es_bloqueante = datos_objeto.bloqueante 
	
	objeto.colocar_en_tablero(espaciado_baldosas, altura_objetos) # posicionar el objeto en el tablero
	
	return objeto


func _obtener_datos_objeto(tipo: int) -> Dictionary: 
	var datos = {
		"nombre": "Obstaculo",
		"ruta_modelo": "",
		"bloqueante": true
	}
	
	if mapas.tipo_obstaculo.has(tipo):
		datos.ruta_modelo = mapas.tipo_obstaculo[tipo]
		datos.nombre = "Tipo_" + str(tipo)
	
	return datos

# MÉTODOS DE PRODUCCIÓN EN MASA
func producir_objetos_desde_mapa(indice_mapa: int = -1) -> void:
	if indice_mapa == -1:
		indice_mapa = globalJuego.mapa_actual 
	
	var datos_mapa = mapas.obtener_mapa_actual(indice_mapa)
	var posiciones = datos_mapa["posiciones"]
	var tipos = datos_mapa["tipos"]
	
	
	for i in range(posiciones.size()):
		var posicion = posiciones[i]
		var tipo = tipos[i] if i < tipos.size() else 1
		
		var objeto = crear_objeto(tipo, posicion)
		if objeto:
			add_child(objeto)
			objetos_instanciados.append(objeto)
			_marcar_baldosa_como_ocupada(posicion)

func producir_objeto_individual(tipo: int, posicion: Vector2i) -> ObjetoBase:
	"""Crea un único objeto en una posición específica"""
	if _existe_objeto_en_posicion(posicion):
		push_warning("Ya existe un objeto en ", posicion)
		return null
	
	var objeto = crear_objeto(tipo, posicion)
	if objeto:
		add_child(objeto)
		objetos_instanciados.append(objeto)
		_marcar_baldosa_como_ocupada(posicion)
	
	return objeto

func _marcar_baldosa_como_ocupada(posicion: Vector2i) -> void:
	if not gestor_tablero:
		return
	
	var baldosa = gestor_tablero.obtener_baldosa_en_coordenadas(posicion)
	if baldosa:
		if baldosa.has_method("marcar_como_bloqueada"):
			baldosa.marcar_como_bloqueada()
		else:
			baldosa.set_meta("bloqueada", true)

# MÉTODOS DE CONSULTA

func _existe_objeto_en_posicion(posicion: Vector2i) -> bool:
	for objeto in objetos_instanciados:
		if is_instance_valid(objeto) and objeto.posicion_tablero == posicion:
			return true
	return false

func obtener_objeto_en_posicion(posicion: Vector2i) -> ObjetoBase:
	for objeto in objetos_instanciados:
		if is_instance_valid(objeto) and objeto.posicion_tablero == posicion:
			return objeto
	return null

func es_posicion_ocupada(posicion: Vector2i) -> bool:
	var indice_mapa = globalJuego.mapa_actual if globalJuego.has("mapa_actual") else 0
	return mapas.es_posicion_bloqueada(posicion, indice_mapa)

# MÉTODOS DE LIMPIEZA Y RECARGA

func limpiar_todos_objetos() -> void:
	for objeto in objetos_instanciados:
		if is_instance_valid(objeto):
			objeto.queue_free()
	objetos_instanciados.clear()

func cargar_objetos_del_mapa() -> void:
	limpiar_todos_objetos()
	
	if not gestor_tablero:
		push_error("FabricaObjetos: No hay referencia al tablero")
		return
	
	producir_objetos_desde_mapa()

# SEÑALES Y EVENTOS

func _on_mapa_cambiado(nuevo_mapa: int) -> void:
	cargar_objetos_del_mapa()
