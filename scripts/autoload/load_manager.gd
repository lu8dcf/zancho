extends Node

signal progreso_cambio(progreso)
signal termina_carga

var _pantalla_carga_path : String = "res://scenes/cargando.tscn"
var _pantalla_carga = load(_pantalla_carga_path)
var _carga_recursos : PackedScene
var _escena_path: String
var _progreso : Array = []

var multiples_procesos : bool = true
var pantalla_instancia = null

#  progreso simulado
var _progreso_mostrado: float = 0.0
var _progreso_real: float = 0.0
var _carga_completada: bool = false
var _animacion_iniciada: bool = false
var _velocidad_simulada: float = 0.5  


func cargar_escena(path: String):
	_escena_path = path
	
	# Resetear variables
	_progreso_mostrado = 0.0
	_progreso_real = 0.0
	_carga_completada = false
	_animacion_iniciada = false
	
	pantalla_instancia = _pantalla_carga.instantiate()
	pantalla_instancia = _pantalla_carga.instantiate()
	get_tree().get_root().add_child(pantalla_instancia)
	
	self.progreso_cambio.connect(pantalla_instancia._actualiza_progreso_barra)
	self.termina_carga.connect(pantalla_instancia._empieza_animacion)

	await get_tree().process_frame
	empieza_carga()
	
	await pantalla_instancia.pantalla_carga_barra_lleno
	
	if progreso_cambio.is_connected(pantalla_instancia._actualiza_progreso_barra):
		progreso_cambio.disconnect(pantalla_instancia._actualiza_progreso_barra)
	if termina_carga.is_connected(pantalla_instancia._empieza_animacion):
		termina_carga.disconnect(pantalla_instancia._empieza_animacion)
	
	get_tree().change_scene_to_packed(_carga_recursos)


func empieza_carga():
	var estado = ResourceLoader.load_threaded_request(_escena_path, "", multiples_procesos)
	if estado == OK:
		set_process(true)
	else:
		print("error.. ", estado)


func _process(delta: float) -> void:
	if not _carga_completada:
		var estado_carga = ResourceLoader.load_threaded_get_status(_escena_path, _progreso)
		match estado_carga:
			ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
				set_process(false)
				print("Error en la carga del recurso")
				return
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				_progreso_real = _progreso[0]
			ResourceLoader.THREAD_LOAD_LOADED:
				_carga_recursos = ResourceLoader.load_threaded_get(_escena_path)
				_progreso_real = 1.0
				_carga_completada = true
	
	# simular barra de progreso suave
	if not _animacion_iniciada:
		if _progreso_mostrado < _progreso_real:
			_progreso_mostrado += delta * _velocidad_simulada
			if _progreso_mostrado > _progreso_real:
				_progreso_mostrado = _progreso_real
			emit_signal("progreso_cambio", _progreso_mostrado)
		
		#al llegar 100% y la carga está completa, iniciar animación
		if _carga_completada and _progreso_mostrado >= 0.99:
			_progreso_mostrado = 1.0
			emit_signal("progreso_cambio", 1.0)
			_animacion_iniciada = true
			emit_signal("termina_carga") 
