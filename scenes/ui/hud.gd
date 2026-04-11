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
@onready var tienda_botones = $Control/PanelTienda/PanelContainer
@onready var monedas_label = $Control/PanelTienda/monedas

func _ready():
	# ocultar la tienda
	tienda_contenido.visible = false
	# Conectar las señales globales para actualizar la UI automáticamente
	GlobalJuego.monedas_cambiadas.connect(_actualizar_monedas)
	GlobalJuego.vidas_cambiadas.connect(_actualizar_vidas)
	GlobalJuego.oleada_cambiada.connect(_actualizar_oleada)
	#GlobalJuego.tienda_estado_cambiado.connect(_actualizar_tienda)
	
	# Actualizar valores iniciales
	_actualizar_monedas(GlobalJuego.monedas)
	_actualizar_vidas(GlobalJuego.vidas)
	_actualizar_oleada(GlobalJuego.oleada_actual)
	
func _actualizar_monedas(nuevas_monedas: int) -> void:
	monedas_label.text = "💰 " + str(nuevas_monedas)

func _actualizar_vidas(nuevas_vidas: int) -> void:
	vidas_label.text = "❤️ " + str(nuevas_vidas) + "/" + str(GlobalJuego.vidaMax)

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
