extends CanvasLayer

#panel inferior
@onready var panel_inferior: Panel = $PanelInferior
@onready var imagen_back_inferior: TextureRect = $imagenBackInferior
@onready var panel_rey: Panel = $imagenBackInferior/PanelRey


#panel superior
@onready var panel_superior: Panel = $PanelSuperior

# texto debug
@onready var label_debug_temporal: Label = $Label_debug_temporal

# pantalla temporal de ganar
@onready var imagen_oleada: TextureRect = $GanoOleada
var gano = load("res://assets/ui/gano_oleada.png")
var perdio = load("res://assets/ui/perdiste.jpg")

var tween : Tween

func _ready():
	mostrar_todos_paneles()
	imagen_oleada.modulate.a = 0  
	imagen_oleada.visible = false
	label_debug_temporal.text = "Debug: " + str(globalJuego.debug) # true y # false
	# ocultar la tienda
	GlobalSignal.finalizaOleada.connect(mostrar_imagen)
	

func mostrar_todos_paneles():
	panel_inferior.visible = true
	panel_superior.visible = true
	panel_rey.visible = true
	
func mostrar_imagen(ganar: int) -> void:
	globalJuego.empezo_oleada=false
	$PanelTienda._ocultar_tienda()
	if ganar:
		imagen_oleada.texture = gano
		mostras_desaparecer_imagen()
		
		globalJuego.siguiente_oleada() # cambia la oleada a la siguiete
	else:
		imagen_oleada.texture = perdio
		mostras_desaparecer_imagen()
		print("perdiste, reiniicando la oleada...")
		globalJuego.perder_fe(5)
		
func mostras_desaparecer_imagen():
	# Matar tween anterior si existe
		if tween and tween.is_valid():
			tween.kill()
		
		tween = create_tween()
		imagen_oleada.visible = true
		imagen_oleada.modulate.a = 0
		
		# Fade in: aparece en 0.5 segundos
		tween.tween_property(imagen_oleada, "modulate:a", 1.0, 0.5)
		# Espera 2 segundos visible
		tween.tween_interval(4.0)
		# Fade out: desaparece en 0.5 segundos
		tween.tween_property(imagen_oleada, "modulate:a", 0.0, 0.5)
		# Al terminar, ocultar completamente
		tween.tween_callback(_ocultar_imagen)


func _ocultar_imagen() -> void:
	imagen_oleada.visible = false
