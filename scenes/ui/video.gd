extends MenuBar


# configuraciones
@onready var pantalla_lista: OptionButton = $pantalla/pantalla_lista
@onready var resolucion_lista: OptionButton = $resolucion/resolucion_lista
@onready var graficos_lista: OptionButton = $graficos/graficos_lista

# para guardar el archivo en :
const CONFIG_PATH = "user://configuracion.cfg"

#valores graficos
enum CalidadGraficos {
	BAJA = 0,
	MEDIA = 1,
	ALTA = 2,
	ULTRA = 3
}


func _ready() -> void:
	cargar_configuracion() # cargar lo que ya habia guardado
	pantalla_lista.item_selected.connect(_on_modo_pantalla_cambiado)
	resolucion_lista.item_selected.connect(_on_resolucion_cambiado)
	graficos_lista.item_selected.connect(_on_graficos_cambiado)


func cargar_configuracion():
	var config = ConfigFile.new()
	if config.load(CONFIG_PATH) == OK:
		# cargar modo de pantalla
		var modo_pantalla = config.get_value("video", "modo_pantalla", 0)
		pantalla_lista.select(modo_pantalla)
		aplicar_modo_pantalla(modo_pantalla)
		
		# cargar resolución
		var resolucion_idx = config.get_value("video", "resolucion_idx", 1)
		resolucion_lista.select(resolucion_idx)
		aplicar_resolucion(resolucion_idx)
		
		# cargar graficos
		var calidad_idx = config.get_value("video", "calidad_graficos", 1)
		graficos_lista.select(calidad_idx)
		aplicar_calidad_graficos(calidad_idx)
	else:
		pantalla_lista.select(0) 
		resolucion_lista.select(1)  
		graficos_lista.select(1)
		aplicar_modo_pantalla(0)
		aplicar_resolucion(1)
		aplicar_calidad_graficos(1)

func guardar_configuracion():
	var config = ConfigFile.new()
	
	# guardado de conf de video
	config.set_value("video", "modo_pantalla", pantalla_lista.selected)
	config.set_value("video", "resolucion_idx", resolucion_lista.selected)
	config.set_value("video", "calidad_graficos", graficos_lista.selected)

	config.save(CONFIG_PATH)

func _on_modo_pantalla_cambiado(index: int):
	aplicar_modo_pantalla(index)

func _on_resolucion_cambiado(index: int):
	aplicar_resolucion(index)

func _on_graficos_cambiado(index: int):
	aplicar_calidad_graficos(index)
	
func aplicar_modo_pantalla(index: int):
	match index:
		0: # pantalla Completa
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1: # ventana
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			
		2: # ventana sin bordes
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

func aplicar_resolucion(index: int):
	var resoluciones = [
		Vector2i(1280, 720),   # hd
		Vector2i(1920, 1080),  # full hd
		Vector2i(2560, 1440)   # 2k
	]
	
	if index >= 0 and index < resoluciones.size():
		var resolucion = resoluciones[index]
		#solo se cambia la resolucion estando en modo ventana
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_size(resolucion)
			
			# centrar la ventana
			var pantalla = DisplayServer.screen_get_size()
			var pos_x = (pantalla.x - resolucion.x) / 2
			var pos_y = (pantalla.y - resolucion.y) / 2
			DisplayServer.window_set_position(Vector2i(pos_x, pos_y))
		
func aplicar_calidad_graficos(index: int):
	match index:
		CalidadGraficos.BAJA:
			_aplicar_configuracion_baja()
		CalidadGraficos.MEDIA:
			_aplicar_configuracion_media()
		CalidadGraficos.ALTA:
			_aplicar_configuracion_alta()
		CalidadGraficos.ULTRA:
			_aplicar_configuracion_ultra()
	
	_aplicar_calidad_particulas(index)
	_ajustar_sombras_luces(get_tree().root, index)
	_ajustar_camaras(get_tree().root,index)
	
func _on_guardar_pressed() -> void:
	guardar_configuracion()
	$"../..".esconder_todo()

func _aplicar_configuracion_baja():
	# Anti-aliasing desactivado
	var viewport = get_viewport()
	if viewport:
		viewport.msaa_3d = Viewport.MSAA_DISABLED
		viewport.scaling_3d_scale = 0.7  # Reducir escala de renderizado 3D
		viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		viewport.use_taa = false
		viewport.use_debanding = false
		viewport.scaling_3d_scale = 0.6

	# VSync desactivado
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	Engine.max_fps = 60
	quitar_todas_las_sombras(get_tree().root)
	
		

func quitar_todas_las_sombras(nodo: Node) -> void:
	if nodo is Light3D:
		nodo.shadow_enabled = false
	if nodo is GeometryInstance3D:
		nodo.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	for hijo in nodo.get_children():
		quitar_todas_las_sombras(hijo)
		
		
func _aplicar_configuracion_media():
	var viewport = get_viewport()
	if viewport:
		viewport.msaa_3d = Viewport.MSAA_2X
		viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
		viewport.use_taa = false
		viewport.scaling_3d_scale = 0.8
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	Engine.max_fps = 60


func _aplicar_configuracion_alta():
	var viewport = get_viewport()
	if viewport:
		viewport.msaa_3d = Viewport.MSAA_4X
		viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
		viewport.use_taa = true
		viewport.scaling_3d_scale = 1.0
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	Engine.max_fps = 120



func _aplicar_configuracion_ultra():
	var viewport = get_viewport()
	if viewport:
		viewport.msaa_3d = Viewport.MSAA_8X
		viewport.scaling_3d_scale = 1.0
	
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)

func _aplicar_calidad_particulas(nivel: int):
	# Buscar todos los sistemas de partículas en la escena actual
	var arbol = get_tree()
	if arbol:
		_aplicar_particulas_recursivo(arbol.root, nivel)
		
		# Conectar señal para aplicar a futuros nodos
		if not arbol.node_added.is_connected(_on_nodo_añadido):
			arbol.node_added.connect(_on_nodo_añadido)
			
func _guardar_valores_originales_particulas(p: Node) -> void:
	if not p.has_meta("original_amount"):
		p.set_meta("original_amount", p.amount)
	if not p.has_meta("original_lifetime"):
		p.set_meta("original_lifetime", p.lifetime)
	if "fixed_fps" in p and not p.has_meta("original_fixed_fps"):
		p.set_meta("original_fixed_fps", p.fixed_fps)
	
func _aplicar_particulas_recursivo(nodo: Node, nivel: int):
	if nodo is GPUParticles3D or nodo is GPUParticles2D or nodo is CPUParticles3D:
		_guardar_valores_originales_particulas(nodo)

		var base_amount: int = nodo.get_meta("original_amount")
		var base_lifetime: float = nodo.get_meta("original_lifetime")

		match nivel:
			CalidadGraficos.BAJA:
				nodo.amount = max(1, int(base_amount * 0.25))
				nodo.lifetime = base_lifetime * 0.7
				if "fixed_fps" in nodo:
					nodo.fixed_fps = 15

			CalidadGraficos.MEDIA:
				nodo.amount = max(1, int(base_amount * 0.5))
				nodo.lifetime = base_lifetime * 0.85
				if "fixed_fps" in nodo:
					nodo.fixed_fps = 30

			CalidadGraficos.ALTA:
				nodo.amount = max(1, int(base_amount * 0.75))
				nodo.lifetime = base_lifetime
				if "fixed_fps" in nodo:
					nodo.fixed_fps = 60

			CalidadGraficos.ULTRA:
				nodo.amount = base_amount
				nodo.lifetime = base_lifetime
				if "fixed_fps" in nodo:
					nodo.fixed_fps = nodo.get_meta("original_fixed_fps", 0)

	for hijo in nodo.get_children():
		_aplicar_particulas_recursivo(hijo, nivel)

func _ajustar_sombras_luces(nodo: Node, calidad: int):
	if nodo is Light3D:
		match calidad:
			CalidadGraficos.BAJA:
				nodo.shadow_enabled = false
			CalidadGraficos.MEDIA:
				nodo.shadow_enabled = nodo is DirectionalLight3D
				#nodo.directional_shadow_size = 1024
			CalidadGraficos.ALTA:
				nodo.shadow_enabled = true
				nodo.directional_shadow_size = 2048
			CalidadGraficos.ULTRA:
				nodo.shadow_enabled = true
				nodo.directional_shadow_size = 4096
	
	if nodo is GeometryInstance3D:
		match calidad:
			CalidadGraficos.BAJA:
				nodo.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

			CalidadGraficos.MEDIA:
				nodo.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON

			CalidadGraficos.ALTA:
				nodo.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON

			CalidadGraficos.ULTRA:
				nodo.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	for hijo in nodo.get_children():
		_ajustar_sombras_luces(hijo, calidad)


func _ajustar_camaras(nodo: Node, calidad: int):
	if nodo is Camera3D:
		match calidad:
			CalidadGraficos.BAJA:
				nodo.far = 150.0
			CalidadGraficos.MEDIA:
				nodo.far = 300.0
			CalidadGraficos.ALTA:
				nodo.far = 600.0
			CalidadGraficos.ULTRA:
				nodo.far = 1000.0

	for hijo in nodo.get_children():
		_ajustar_camaras(hijo, calidad)

func _on_nodo_añadido(nodo: Node):
	# Aplicar calidad de partículas a nuevos nodos que se añadan a la escena
	_aplicar_particulas_recursivo(nodo, graficos_lista.selected)
	
func _on_restablecer_pressed() -> void:
	pantalla_lista.select(0) # Pantalla completa por defecto
	resolucion_lista.select(1)  # Resolución media por defecto
	graficos_lista.select(1)  # graficos media por defecto
	aplicar_modo_pantalla(0)
	aplicar_resolucion(1)
	aplicar_calidad_graficos(1)
	guardar_configuracion()
