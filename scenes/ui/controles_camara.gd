extends Label

# controles camara
@onready var der_edit: LineEdit = $Container_camera/der/der_edit
@onready var izq_edit: LineEdit = $Container_camera/izq/izq_edit
@onready var arr_edit: LineEdit = $Container_camera/arriba/arr_edit
@onready var aba_edit: LineEdit = $Container_camera/abajo/aba_edit
@onready var reini_edit: LineEdit = $Container_camera/reiniciar_camara/reini_edit
@onready var as_edit: LineEdit = $Container_camera/ascender/as_edit
@onready var des_edit: LineEdit = $Container_camera/descender/des_edit
@onready var zoom_edit: LineEdit = $Container_camera/zoom/zoom_edit

# controles de jugabilidad
@onready var pausar_edit: LineEdit = $"../../boton_jugabilidad/controles_jugabilidad/Container_jugabilidad/pausar_oleada/pausar_edit"
@onready var ace_1_edit: LineEdit = $"../../boton_jugabilidad/controles_jugabilidad/Container_jugabilidad/acelerar_1_oleada2/ace1_edit"
@onready var ace_2_edit: LineEdit = $"../../boton_jugabilidad/controles_jugabilidad/Container_jugabilidad/acelerar_2_oleada3/ace2_edit"
@onready var empe_edit: LineEdit = $"../../boton_jugabilidad/controles_jugabilidad/Container_jugabilidad/empezar_oleada/empe_edit"
@onready var pau_menu_edit: LineEdit = $"../../boton_jugabilidad/controles_jugabilidad/Container_jugabilidad/pausa_menu/pau_menu_edit"
@onready var ocu_edit: LineEdit = $"../../boton_jugabilidad/controles_jugabilidad/Container_jugabilidad/ocultar_todo/ocu_edit"
@onready var ocu_tienda_edit: LineEdit = $"../../boton_jugabilidad/controles_jugabilidad/Container_jugabilidad/ocultar_tienda/ocu_tienda_edit"


@onready var guardar: TextureButton = $"../../guardar"
const CONFIG_PATH = "user://configuracion.cfg"


func _ready() -> void:
	cargar_configuracion()
	predeterminarEdit()
	personalizar_line_edits()
	conectar_señales()

func conectar_señales():
	# Cámara
	der_edit.gui_input.connect(_on_line_edit_input.bind(der_edit, "Mover derecha"))
	izq_edit.gui_input.connect(_on_line_edit_input.bind(izq_edit, "Mover izquierda"))
	arr_edit.gui_input.connect(_on_line_edit_input.bind(arr_edit, "Mover adelante"))
	aba_edit.gui_input.connect(_on_line_edit_input.bind(aba_edit, "Mover atras"))
	reini_edit.gui_input.connect(_on_line_edit_input.bind(reini_edit, "resetear_camara"))
	as_edit.gui_input.connect(_on_line_edit_input.bind(as_edit, "Ascender"))
	des_edit.gui_input.connect(_on_line_edit_input.bind(des_edit, "Descender"))
	zoom_edit.gui_input.connect(_on_line_edit_input.bind(zoom_edit, "zoom_de_camara"))
	
	# Jugabilidad
	pausar_edit.gui_input.connect(_on_line_edit_input.bind(pausar_edit, "pausa_oleada"))
	ace_1_edit.gui_input.connect(_on_line_edit_input.bind(ace_1_edit, "acelerar1"))
	ace_2_edit.gui_input.connect(_on_line_edit_input.bind(ace_2_edit, "acelerar2"))
	empe_edit.gui_input.connect(_on_line_edit_input.bind(empe_edit, "empezar_oleada"))
	pau_menu_edit.gui_input.connect(_on_line_edit_input.bind(pau_menu_edit, "pausa_menu"))
	ocu_edit.gui_input.connect(_on_line_edit_input.bind(ocu_edit, "ocultar_todo"))
	ocu_tienda_edit.gui_input.connect(_on_line_edit_input.bind(ocu_tienda_edit, "ocultar_tienda"))

func cargar_configuracion():
	var config = ConfigFile.new()
	if config.load(CONFIG_PATH) == OK:
		for accion in config.get_sections():
			var tecla = config.get_value(accion, "tecla", "")
			if tecla != "":
				aplicar_tecla_a_input_map(accion, tecla)

func guardar_configuracion():
	var config = ConfigFile.new()
	
	if config.load(CONFIG_PATH) == OK:
		pass
	
	# Cámara
	guardar_tecla_en_config(config, "Mover derecha", der_edit.text)
	guardar_tecla_en_config(config, "Mover izquierda", izq_edit.text)
	guardar_tecla_en_config(config, "Mover adelante", arr_edit.text)
	guardar_tecla_en_config(config, "Mover atras", aba_edit.text)
	guardar_tecla_en_config(config, "resetear_camara", reini_edit.text)
	guardar_tecla_en_config(config, "Ascender", as_edit.text)
	guardar_tecla_en_config(config, "Descender", des_edit.text)
	guardar_tecla_en_config(config, "zoom_de_camara", zoom_edit.text)
	
	# Jugabilidad
	guardar_tecla_en_config(config, "pausa_oleada", pausar_edit.text)
	guardar_tecla_en_config(config, "acelerar1", ace_1_edit.text)
	guardar_tecla_en_config(config, "acelerar2", ace_2_edit.text)
	guardar_tecla_en_config(config, "empezar_oleada", empe_edit.text)
	guardar_tecla_en_config(config, "pausa_menu", pau_menu_edit.text)
	guardar_tecla_en_config(config, "ocultar_todo", ocu_edit.text)
	guardar_tecla_en_config(config, "ocultar_tienda", ocu_tienda_edit.text)
	
	config.save(CONFIG_PATH)

func guardar_tecla_en_config(config: ConfigFile, accion: String, tecla: String):
	if tecla != "":
		config.set_value(accion, "tecla", tecla)
		
func _on_line_edit_input(event: InputEvent, edit: LineEdit, _accion: String):
	if event is InputEventKey and event.pressed:
		# Capturar la tecla, incluyendo espacio
		var key_text = OS.get_keycode_string(event.keycode)
		
		# Si es espacio, OS.get_keycode_string devuelve ""
		if event.keycode == KEY_SPACE:
			key_text = "Espacio"
		
		edit.text = key_text
		edit.release_focus()

func _on_guardar_pressed():
	# Cámara
	actualizar_input_map("Mover derecha", der_edit.text)
	actualizar_input_map("Mover izquierda", izq_edit.text)
	actualizar_input_map("Mover adelante", arr_edit.text)
	actualizar_input_map("Mover atras", aba_edit.text)
	actualizar_input_map("resetear_camara", reini_edit.text)
	actualizar_input_map("Ascender", as_edit.text)
	actualizar_input_map("Descender", des_edit.text)
	actualizar_input_map("zoom_de_camara", zoom_edit.text)
	
	# Jugabilidad
	actualizar_input_map("pausa_oleada", pausar_edit.text)
	actualizar_input_map("acelerar1", ace_1_edit.text)
	actualizar_input_map("acelerar2", ace_2_edit.text)
	actualizar_input_map("empezar_oleada", empe_edit.text)
	actualizar_input_map("pausa_menu", pau_menu_edit.text)
	actualizar_input_map("ocultar_todo", ocu_edit.text)
	actualizar_input_map("ocultar_tienda", ocu_tienda_edit.text)
	
	guardar_configuracion()
	predeterminarEdit()
	$"../../../..".esconder_todo()
	
	
func aplicar_tecla_a_input_map(accion: String, tecla: String):
	var keycode = buscar_keycode_por_texto(tecla)
	if keycode == 0:
		return
	
	# Si la acción no existe, la creamos
	if not InputMap.has_action(accion):
		InputMap.add_action(accion)
	
	InputMap.action_erase_events(accion)
	
	var nuevo_evento = InputEventKey.new()
	nuevo_evento.keycode = keycode
	nuevo_evento.physical_keycode = keycode
	
	InputMap.action_add_event(accion, nuevo_evento)
	
func actualizar_input_map(accion: String, tecla_texto: String):
	if tecla_texto == "":
		return
	
	# Buscar el keycode correspondiente al texto
	var keycode = buscar_keycode_por_texto(tecla_texto)
	if keycode == 0:
		return
	
	# Si la acción no existe, la creamos
	if not InputMap.has_action(accion):
		InputMap.add_action(accion)
	
	# Limpiar eventos anteriores de la acción
	InputMap.action_erase_events(accion)
	
	# Crear nuevo evento de tecla
	var nuevo_evento = InputEventKey.new()
	nuevo_evento.keycode = keycode
	nuevo_evento.physical_keycode = keycode
	
	# Añadir el nuevo evento
	InputMap.action_add_event(accion, nuevo_evento)

func buscar_keycode_por_texto(texto: String) -> int:
	var key_map = {
		"A": KEY_A, "B": KEY_B, "C": KEY_C, "D": KEY_D, "E": KEY_E,
		"F": KEY_F, "G": KEY_G, "H": KEY_H, "I": KEY_I, "J": KEY_J,
		"K": KEY_K, "L": KEY_L, "M": KEY_M, "N": KEY_N, "O": KEY_O,
		"P": KEY_P, "Q": KEY_Q, "R": KEY_R, "S": KEY_S, "T": KEY_T,
		"U": KEY_U, "V": KEY_V, "W": KEY_W, "X": KEY_X, "Y": KEY_Y,
		"Z": KEY_Z,
		"0": KEY_0, "1": KEY_1, "2": KEY_2, "3": KEY_3, "4": KEY_4,
		"5": KEY_5, "6": KEY_6, "7": KEY_7, "8": KEY_8, "9": KEY_9,
		"←": KEY_LEFT, "→": KEY_RIGHT, "↑": KEY_UP, "↓": KEY_DOWN,
		"Espacio": KEY_SPACE, "Enter": KEY_ENTER, "Esc": KEY_ESCAPE,
		"Tab": KEY_TAB, "Shift": KEY_SHIFT, "Ctrl": KEY_CTRL,
		"Alt": KEY_ALT
	}
	
	return key_map.get(texto, 0)

func predeterminarEdit():
	# Cámara
	var der_events = InputMap.action_get_events("Mover derecha")
	var izq_events = InputMap.action_get_events("Mover izquierda")
	var arr_events = InputMap.action_get_events("Mover adelante")
	var aba_events = InputMap.action_get_events("Mover atras")
	var reini_events = InputMap.action_get_events("resetear_camara")
	var as_events = InputMap.action_get_events("Ascender")
	var des_events = InputMap.action_get_events("Descender")
	var zoom_events = InputMap.action_get_events("zoom_de_camara")
	
	# Jugabilidad
	var pausar_events = InputMap.action_get_events("pausa_oleada")
	var ace1_events = InputMap.action_get_events("acelerar1")
	var ace2_events = InputMap.action_get_events("acelerar2")
	var empe_events = InputMap.action_get_events("empezar_oleada")
	var pau_menu_events = InputMap.action_get_events("pausa_menu")
	var ocu_events = InputMap.action_get_events("ocultar_todo")
	var ocu_tienda_events = InputMap.action_get_events("ocultar_tienda")
	
	# Cámara
	der_edit.placeholder_text = obtener_nombre_tecla(der_events)
	izq_edit.placeholder_text = obtener_nombre_tecla(izq_events)
	arr_edit.placeholder_text = obtener_nombre_tecla(arr_events)
	aba_edit.placeholder_text = obtener_nombre_tecla(aba_events)
	reini_edit.placeholder_text = obtener_nombre_tecla(reini_events)
	as_edit.placeholder_text = obtener_nombre_tecla(as_events)
	des_edit.placeholder_text = obtener_nombre_tecla(des_events)
	zoom_edit.placeholder_text = obtener_nombre_tecla(zoom_events)
	
	# Jugabilidad
	pausar_edit.placeholder_text = obtener_nombre_tecla(pausar_events)
	ace_1_edit.placeholder_text = obtener_nombre_tecla(ace1_events)
	ace_2_edit.placeholder_text = obtener_nombre_tecla(ace2_events)
	empe_edit.placeholder_text = obtener_nombre_tecla(empe_events)
	pau_menu_edit.placeholder_text = obtener_nombre_tecla(pau_menu_events)
	ocu_edit.placeholder_text = obtener_nombre_tecla(ocu_events)
	ocu_tienda_edit.placeholder_text = obtener_nombre_tecla(ocu_tienda_events)
	
	# Limpiar todos los textos
	der_edit.text = ""
	izq_edit.text = ""
	arr_edit.text = ""
	aba_edit.text = ""
	reini_edit.text = ""
	as_edit.text = ""
	des_edit.text = ""
	zoom_edit.text = ""
	
	pausar_edit.text = ""
	ace_1_edit.text = ""
	ace_2_edit.text = ""
	empe_edit.text = ""
	pau_menu_edit.text = ""
	ocu_edit.text = ""
	ocu_tienda_edit.text = ""
	

func personalizar_line_edits():
	var line_edits = [der_edit, izq_edit, arr_edit, aba_edit, reini_edit, as_edit, des_edit, zoom_edit,
					  pausar_edit, ace_1_edit, ace_2_edit, empe_edit, pau_menu_edit, ocu_edit, ocu_tienda_edit]
	
	for edit in line_edits:
		# Colores
		edit.add_theme_color_override("font_color", Color.BLACK)
		edit.add_theme_color_override("font_placeholder_color", Color(0.4, 0.4, 0.4, 1))
		edit.add_theme_color_override("caret_color", Color.BLACK)
		edit.add_theme_color_override("selection_color", Color(0.2, 0.5, 1, 0.3))
		
		
		# Fondo blanco
		var normal_style = StyleBoxFlat.new()
		normal_style.bg_color = Color.WHITE
		normal_style.border_width_left = 1
		normal_style.border_width_right = 1
		normal_style.border_width_top = 1
		normal_style.border_width_bottom = 1
		normal_style.border_color = Color(0.5, 0.5, 0.5, 1)
		
		normal_style.set_corner_radius_all(4)
		
		edit.add_theme_stylebox_override("normal", normal_style)
		
		# Liberar foco
		edit.release_focus()

func obtener_nombre_tecla(events: Array) -> String:
	if events.is_empty():
		return "Sin asignar"
	
	var event = events[0]
	
	if event is InputEventKey:
		# Usar keycode (lógico) en lugar de physical_keycode
		var keycode = event.keycode
		
		# Si es 0 (tecla no reconocida), usar physical_keycode como respaldo
		if keycode == 0:
			keycode = event.physical_keycode
		
		# Obtener el nombre limpio de la tecla
		var key_name = OS.get_keycode_string(keycode)
		
		# Manejar casos especiales
		if key_name == "":
			# Mapa manual para teclas especiales
			match event.physical_keycode:
				KEY_LEFT: return "←"
				KEY_RIGHT: return "→"
				KEY_UP: return "↑"
				KEY_DOWN: return "↓"
				KEY_SPACE: return "Espacio"
				KEY_ENTER: return "Enter"
				KEY_ESCAPE: return "Esc"
				KEY_TAB: return "Tab"
				_: return "Tecla"
		else:
			return key_name
	
	elif event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT: return "Click Izq"
			MOUSE_BUTTON_RIGHT: return "Click Der"
			MOUSE_BUTTON_MIDDLE: return "Click Med"
			_: return "M" + str(event.button_index)
	
	elif event is InputEventJoypadButton:
		return "JB" + str(event.button_index)
	
	elif event is InputEventJoypadMotion:
		return "JA" + str(event.axis)
	
	return "?"
