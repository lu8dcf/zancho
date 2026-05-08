extends CanvasLayer


# panel inferior
@onready var contenedor_piezas = $Control/PanelInferior

# panel del rey
@onready var vida_rey: TextureButton = $Control/PanelRey/VidaRey
@onready var valor_vida: TextureButton = $Control/PanelRey/ValorVida

# texto debug
@onready var label_debug_temporal: Label = $Control/Label_debug_temporal



func _ready():
	label_debug_temporal.text = "Debug: " + str(globalJuego.debug) # true y # false
	# ocultar la tienda
	
	globalJuego.vidas_cambiadas.connect(_actualizar_vidas)
	
	#globalJuego.tienda_estado_cambiado.connect(_actualizar_tienda)
	
	_actualizar_vidas(globalJuego.vidas)
	
	

func _actualizar_vidas(nuevas_vidas: int) -> void:
	valor_vida.cambiar_texto(str(nuevas_vidas) + "/" + str(globalJuego.vidaMax))
