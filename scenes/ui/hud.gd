extends CanvasLayer

#panel inferior
@onready var panel_inferior: Panel = $PanelInferior
@onready var panel_rey: Panel = $PanelRey
@onready var imagen_back_inferior: TextureRect = $imagenBackInferior


# panel del rey
@onready var valor_vida: TextureButton = $PanelRey/ValorVida
@onready var vida_rey: TextureButton = $PanelRey/VidaRey

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


func _on_boton_esconder_inferior_pressed() -> void:
	panel_inferior.visible=false
	panel_rey.visible =false
	imagen_back_inferior.visible = false
