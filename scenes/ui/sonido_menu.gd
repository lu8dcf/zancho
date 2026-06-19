extends MenuBar

@onready var general_slider: HSlider = $general/general_slider
@onready var musica_slider: HSlider = $musica/musica_slider
@onready var efectos_slider: HSlider = $efectos/efectos_slider
# textos
@onready var label_g: Label = $general/Label_g
@onready var label_m: Label = $musica/Label_m
@onready var label_e: Label = $efectos/Label_e

# donde seguarda el archivo de config
const CONFIG_PATH = "user://configuracion.cfg"

const VOLUMEN_GENERAL_DEFECTO = 100.0
const VOLUMEN_MUSICA_DEFECTO = 80.0
const VOLUMEN_EFECTOS_DEFECTO = 100.0



func _ready() -> void:
	
	configurar_slider(general_slider)
	configurar_slider(musica_slider)
	configurar_slider(efectos_slider)
	
	#señales conectadas
	general_slider.value_changed.connect(_on_general_cambiado)
	musica_slider.value_changed.connect(_on_musica_cambiado)
	efectos_slider.value_changed.connect(_on_efectos_cambiado)
	
	# si hay cambios cambiar el texto de la label
	general_slider.value_changed.connect(func(v): label_g.text = str(int(v)) + "%")
	musica_slider.value_changed.connect(func(v): label_m.text = str(int(v)) + "%")
	efectos_slider.value_changed.connect(func(v): label_e.text = str(int(v)) + "%")
	
	label_g.text = str(int(general_slider.value)) + "%"
	label_m.text = str(int(musica_slider.value)) + "%"
	label_e.text = str(int(efectos_slider.value)) + "%"
	
	cargar_configuracion_sonido()

func configurar_slider(slider: HSlider):
	slider.min_value = 0.0      
	slider.max_value = 100.0    
	slider.step = 1.0           
	slider.value = 100.0
	
func cargar_configuracion_sonido():
	var config = ConfigFile.new()
	if config.load(CONFIG_PATH) == OK:
		# Cargar valores guardados o usar defecto
		general_slider.value = config.get_value("audio", "volumen_general", VOLUMEN_GENERAL_DEFECTO)
		musica_slider.value = config.get_value("audio", "volumen_musica", VOLUMEN_MUSICA_DEFECTO)
		efectos_slider.value = config.get_value("audio", "volumen_efectos", VOLUMEN_EFECTOS_DEFECTO)
	else:
		# Si no hay archivo, usar valores por defecto
		general_slider.value = VOLUMEN_GENERAL_DEFECTO
		musica_slider.value = VOLUMEN_MUSICA_DEFECTO
		efectos_slider.value = VOLUMEN_EFECTOS_DEFECTO
	aplicar_volumenes()

func guardar_configuracion_sonido():
	var config = ConfigFile.new()
	
	if config.load(CONFIG_PATH) != OK: # verifica que ya existe y evita problemas si no existe
		pass
	
	config.set_value("audio", "volumen_general", general_slider.value)
	config.set_value("audio", "volumen_musica", musica_slider.value)
	config.set_value("audio", "volumen_efectos", efectos_slider.value)
	
	config.save(CONFIG_PATH)

func aplicar_volumenes():
	var master_idx = AudioServer.get_bus_index("Master")
	var music_idx = AudioServer.get_bus_index("Music")
	var sfx_idx = AudioServer.get_bus_index("SFX")
	
	AudioServer.set_bus_volume_db(master_idx, linear_to_db(general_slider.value / 100.0))
	AudioServer.set_bus_volume_db(music_idx, linear_to_db(musica_slider.value / 100.0))
	AudioServer.set_bus_volume_db(sfx_idx, linear_to_db(efectos_slider.value / 100.0))

func _on_general_cambiado(valor: float):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"), 
		linear_to_db(valor/100.0)
	)

func _on_musica_cambiado(valor: float):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"), 
		linear_to_db(valor/100.0)
	)

func _on_efectos_cambiado(valor: float):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"), 
		linear_to_db(valor/100.0)
	)

func _on_guardar_pressed() -> void:
	guardar_configuracion_sonido()
	$"../..".esconder_todo()

func _on_restablecer_pressed() -> void:
	general_slider.value = VOLUMEN_GENERAL_DEFECTO
	musica_slider.value = VOLUMEN_MUSICA_DEFECTO
	efectos_slider.value = VOLUMEN_EFECTOS_DEFECTO
	aplicar_volumenes()
