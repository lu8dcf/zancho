extends Panel

@onready var oleada_label = $oleada
@onready var boton_menu = $BotonMenu
@onready var boton_debilidades = $BotonDebilidades
@onready var boton_reiniciar_camera = $BotonReiniciarCamara
@onready var imagen_debilidades = $imagenDebilidades

func _ready() -> void:
	globalJuego.oleada_cambiada.connect(_actualizar_oleada)
	_actualizar_oleada(globalJuego.oleada_actual)
	imagen_debilidades.texture = load("res://assets/ui/debilidades.png")
	imagen_debilidades.visible=false



func _actualizar_oleada(nueva_oleada: int) -> void:
	oleada_label.text = " OLEADA " + str(nueva_oleada)
	



func _on_boton_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main.tscn")


func _on_boton_reiniciar_camara_pressed() -> void:
	var camara = get_tree().get_first_node_in_group("camara_principal")
	
	if camara and camara is CamaraLibre3D:
		camara.reiniciar_posicion()


func _on_boton_debilidades_pressed() -> void:
	if imagen_debilidades.visible:
		imagen_debilidades.visible = false
	else:
		imagen_debilidades.visible = true	
