extends CanvasLayer


# panel inferior
@onready var contenedor_piezas = $Control/PanelInferior
@onready var tienda_animacion: AnimationPlayer = $Control/PanelTienda/tienda_animacion

# panel del rey
@onready var vidas_label = $Control/PanelRey/vida

# panel de la tienda
@onready var tienda_boton = $Control/BotonTienda
@onready var tienda_contenido = $Control/PanelTienda
@onready var tienda_botones = $Control/PanelTienda/ContenedorTienda
@onready var monedas_label = $Control/PanelTienda/monedas


@onready var imagen_debilidades= $Control/PanelSuperior/imagenDebilidades

func _ready():
	# ocultar la tienda
	
	# Conectar las señales globales para actualizar la UI automáticamente
	economia.monedas_cambiadas.connect(_actualizar_monedas)

	globalJuego.vidas_cambiadas.connect(_actualizar_vidas)
	
	#globalJuego.tienda_estado_cambiado.connect(_actualizar_tienda)
	
	# Actualizar valores iniciales
	_actualizar_monedas(economia.monedas_actual)
	_actualizar_vidas(globalJuego.vidas)
	
	
func _actualizar_monedas(nuevas_monedas: int) -> void:
	monedas_label.text = "💰 " + str(nuevas_monedas)

func _actualizar_vidas(nuevas_vidas: int) -> void:
	vidas_label.text = "❤️ " + str(nuevas_vidas) + "/" + str(globalJuego.vidaMax)





func _on_boton_de_despliegue_pressed() -> void:
	tienda_animacion.play("tienda")
