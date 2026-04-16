extends Panel

@onready var oleada_label = $oleada
@onready var boton_menu = $BotonMenu
@onready var boton_debilidades = $BotonDebilidades
@onready var boton_reiniciar_camera = $BotonReiniciarCamara
@onready var imagen_debilidades = $imagenDebilidades
@onready var mapa_label: Label = $mapa

func _ready() -> void:
	globalJuego.oleada_cambiada.connect(_actualizar_oleada)
	globalJuego.mapa_cambiado.connect(_actualizar_mapa)
	_actualizar_oleada(globalJuego.oleada_actual)
	_actualizar_mapa(globalJuego.mapa_actual)
	imagen_debilidades.texture = load("res://assets/ui/debilidades.png")
	imagen_debilidades.visible=false



func _actualizar_oleada(nueva_oleada: int) -> void:
	oleada_label.text = " OLEADA " + str(nueva_oleada)
	
func _actualizar_mapa(nueva_mapa: int) -> void:
	mapa_label.text = " MAPA " + str(nueva_mapa)
	



func _on_boton_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main.tscn")


func _on_boton_reiniciar_camara_pressed() -> void:
	var camara = get_tree().root.find_child("ControlCamara", true, false)
	
	if camara and camara is Node3D:
		camara.reiniciar_posicion()

	globalJuego.mapa_actual +=1
	globalJuego.cambiar_mapa(globalJuego.mapa_actual)



func _on_boton_debilidades_pressed() -> void:
	if imagen_debilidades.visible:
		imagen_debilidades.visible = false
	else:
		imagen_debilidades.visible = true	
