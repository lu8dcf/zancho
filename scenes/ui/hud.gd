extends CanvasLayer

#panel inferior
@onready var panel_inferior: Panel = $PanelInferior
@onready var imagen_back_inferior: TextureRect = $imagenBackInferior
@onready var panel_rey: Panel = $imagenBackInferior/PanelRey


# panel del rey

@onready var vida_rey: TextureButton = $imagenBackInferior/PanelRey/VidaRey
@onready var valor_vida: TextureButton = $imagenBackInferior/PanelRey/ValorVida

#panel superior
@onready var panel_superior: Panel = $PanelSuperior

# texto debug
@onready var label_debug_temporal: Label = $Label_debug_temporal



func _ready():
	mostrar_todos_paneles()
	label_debug_temporal.text = "Debug: " + str(globalJuego.debug) # true y # false
	# ocultar la tienda
	
	globalJuego.vidas_cambiadas.connect(_actualizar_vidas)
	
	#globalJuego.tienda_estado_cambiado.connect(_actualizar_tienda)
	
	_actualizar_vidas(globalJuego.vidas)

func mostrar_todos_paneles():
	panel_inferior.visible = true
	panel_superior.visible = true
	panel_rey.visible=true
	
func _actualizar_vidas(nuevas_vidas: int) -> void:
	valor_vida.cambiar_texto(str(nuevas_vidas) + "/" + str(globalJuego.vidaMax))
