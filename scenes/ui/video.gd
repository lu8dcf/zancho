extends MenuBar

@onready var container_camera: Control = $"../controles_menu/boton_camara/controles_camara/Container_camera"
@onready var container_jugabilidad: Control = $"../controles_menu/boton_jugabilidad/controles_jugabilidad/Container_jugabilidad"
@onready var boton_camara: Button = $"../controles_menu/boton_camara"
@onready var boton_jugabilidad: Button = $"../controles_menu/boton_jugabilidad"

func _ready() -> void:
	container_jugabilidad.visible = false
	container_camera.visible = true
	actualizar_estilo_botones(true, false)

func _on_boton_camara_pressed() -> void:
	container_jugabilidad.visible = false
	container_camera.visible = true
	actualizar_estilo_botones(true, false)

func _on_boton_jugabilidad_pressed() -> void:
	container_jugabilidad.visible = true
	container_camera.visible = false
	actualizar_estilo_botones(false, true)

func actualizar_estilo_botones(camara_activo: bool, jugabilidad_activo: bool):
	var color_activo = Color(0.3, 0.5, 0.8, 1)  # Azul
	var color_inactivo = Color(0.6, 0.6, 0.6, 1)  # Gris
	
	boton_camara.add_theme_color_override("font_color", color_activo if camara_activo else color_inactivo)
	boton_jugabilidad.add_theme_color_override("font_color", color_activo if jugabilidad_activo else color_inactivo)
	
	#  oscurecer/clarificar botones
	boton_camara.modulate = Color(1, 1, 1, 1) if camara_activo else Color(0.7, 0.7, 0.7, 1)
	boton_jugabilidad.modulate = Color(1, 1, 1, 1) if jugabilidad_activo else Color(0.7, 0.7, 0.7, 1)


func _on_guardar_pressed() -> void:
	$"../..".esconder_todo()
