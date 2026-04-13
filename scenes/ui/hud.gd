extends CanvasLayer

# panel superior
@onready var oleada_label = $Control/PanelSuperior/oleada
@onready var boton_menu = $Control/PanelSuperior/BotonMenu

# panel inferior
@onready var contenedor_piezas = $Control/PanelInferior

# panel del rey
@onready var vidas_label = $Control/PanelRey/vida

# panel de la tienda
@onready var tienda_boton = $Control/BotonTienda
@onready var tienda_contenido = $Control/PanelTienda
@onready var tienda_botones = $Control/PanelTienda/ContenedorTienda
@onready var monedas_label = $Control/PanelTienda/monedas


func _ready():
	# ocultar la tienda
	tienda_contenido.visible = false
	# Conectar las señales globales para actualizar la UI automáticamente
	economia.monedas_cambiadas.connect(_actualizar_monedas)

	globalJuego.vidas_cambiadas.connect(_actualizar_vidas)
	globalJuego.oleada_cambiada.connect(_actualizar_oleada)
	#globalJuego.tienda_estado_cambiado.connect(_actualizar_tienda)
	
	# Actualizar valores iniciales
	_actualizar_monedas(economia.monedas_actual)
	_actualizar_vidas(globalJuego.vidas)
	_actualizar_oleada(globalJuego.oleada_actual)
	
func _actualizar_monedas(nuevas_monedas: int) -> void:
	monedas_label.text = "💰 " + str(nuevas_monedas)

func _actualizar_vidas(nuevas_vidas: int) -> void:
	vidas_label.text = "❤️ " + str(nuevas_vidas) + "/" + str(globalJuego.vidaMax)

func _actualizar_oleada(nueva_oleada: int) -> void:
	oleada_label.text = " OLEADA " + str(nueva_oleada)


func _on_button_tienda_pressed() -> void:
	if tienda_boton.text == " + ":
		tienda_contenido.visible = true
		tienda_boton.position = Vector2(815, 285)
		tienda_boton.text = " - "
	else:
		tienda_contenido.visible = false
		tienda_boton.position = Vector2(1110,285)
		tienda_boton.text = " + "


func _on_boton_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main.tscn")


func _on_boton_reiniciar_camara_pressed() -> void:
	var camara = get_tree().get_first_node_in_group("camara_principal")
	
	if camara and camara is CamaraLibre3D:
		camara.reiniciar_posicion()
