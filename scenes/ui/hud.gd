extends CanvasLayer

@onready var oleada_label = $Control/PanelSuperior/oleada
@onready var monedas_label = $Control/PanelSuperior/monedas
@onready var vidas_label = $Control/PanelRey/vida

@onready var contenedor_piezas = $Control/PanelInferior
@onready var tienda_boton = $Control/ButtonTienda
@onready var tienda_contenido = $Control/PanelTienda

func _ready():
	# ocultar la tienda
	tienda_contenido.visible = false
	# 1. Conectar las señales globales para actualizar la UI automáticamente
	GlobalJuego.monedas_cambiadas.connect(_actualizar_monedas)
	GlobalJuego.vidas_cambiadas.connect(_actualizar_vidas)
	GlobalJuego.oleada_cambiada.connect(_actualizar_oleada)
	#GlobalJuego.tienda_estado_cambiado.connect(_actualizar_tienda)
	
	# 2. Actualizar valores iniciales
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
