extends MenuBar


# configuraciones
@onready var pantalla_lista: OptionButton = $pantalla/pantalla_lista
@onready var resolucion_lista: OptionButton = $resolucion/resolucion_lista

# para guardar el archivo en :
const CONFIG_PATH = "user://configuracion.cfg"


func _ready() -> void:
	cargar_configuracion() # cargar lo que ya habia guardado
	pantalla_lista.item_selected.connect(_on_modo_pantalla_cambiado)
	resolucion_lista.item_selected.connect(_on_resolucion_cambiado)


func cargar_configuracion():
	var config = ConfigFile.new()
	if config.load(CONFIG_PATH) == OK:
		# Cargar modo de pantalla
		var modo_pantalla = config.get_value("video", "modo_pantalla", 0)
		pantalla_lista.select(modo_pantalla)
		aplicar_modo_pantalla(modo_pantalla)
		
		# Cargar resolución
		var resolucion_idx = config.get_value("video", "resolucion_idx", 1)
		resolucion_lista.select(resolucion_idx)
		aplicar_resolucion(resolucion_idx)
	else:
		# Si no hay configuración, usar valores por defecto
		pantalla_lista.select(0) # Pantalla completa por defecto
		resolucion_lista.select(1)  # Resolución media por defecto

func guardar_configuracion():
	var config = ConfigFile.new()
	
	# Guardar modo de pantalla
	config.set_value("video", "modo_pantalla", pantalla_lista.selected)
	
	# Guardar resolución
	config.set_value("video", "resolucion_idx", resolucion_lista.selected)
	
	# Guardar archivo
	config.save(CONFIG_PATH)

func _on_modo_pantalla_cambiado(index: int):
	aplicar_modo_pantalla(index)

func _on_resolucion_cambiado(index: int):
	aplicar_resolucion(index)

func aplicar_modo_pantalla(index: int):
	match index:
		0: # Pantalla Completa
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1: # Ventana
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		2: # Ventana sin bordes
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

func aplicar_resolucion(index: int):
	var resoluciones = [
		Vector2i(1280, 720),   # HD
		Vector2i(1920, 1080),  # Full HD
		Vector2i(2560, 1440)   # 2K
	]
	
	if index >= 0 and index < resoluciones.size():
		var resolucion = resoluciones[index]
		DisplayServer.window_set_size(resolucion)
		
		# Centrar la ventana
		var pantalla = DisplayServer.screen_get_size()
		var pos_x = (pantalla.x - resolucion.x) / 2
		var pos_y = (pantalla.y - resolucion.y) / 2
		DisplayServer.window_set_position(Vector2i(pos_x, pos_y))
		

func _on_guardar_pressed() -> void:
	guardar_configuracion()
	$"../..".esconder_todo()


func _on_restablecer_pressed() -> void:
	pantalla_lista.select(0) # Pantalla completa por defecto
	resolucion_lista.select(1)  # Resolución media por defecto
	guardar_configuracion()
