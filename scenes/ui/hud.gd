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
@onready var gano_oleada: TextureRect = $GanoOleada

var tween : Tween

func _ready():
	mostrar_todos_paneles()
	gano_oleada.modulate.a = 0  
	gano_oleada.visible = false
	label_debug_temporal.text = "Debug: " + str(globalJuego.debug) # true y # false
	# ocultar la tienda
	GlobalSignal.finalizaOleada.connect(mostrar_gano)
	

func mostrar_todos_paneles():
	panel_inferior.visible = true
	panel_superior.visible = true
	panel_rey.visible = true
	
func mostrar_gano(ganar: int) -> void:
	globalJuego.empezo_oleada=false
	if ganar:
		# Matar tween anterior si existe
		if tween and tween.is_valid():
			tween.kill()
		
		tween = create_tween()
		gano_oleada.visible = true
		gano_oleada.modulate.a = 0
		
		# Fade in: aparece en 0.5 segundos
		tween.tween_property(gano_oleada, "modulate:a", 1.0, 0.5)
		# Espera 2 segundos visible
		tween.tween_interval(4.0)
		# Fade out: desaparece en 0.5 segundos
		tween.tween_property(gano_oleada, "modulate:a", 0.0, 0.5)
		# Al terminar, ocultar completamente
		tween.tween_callback(_ocultar_gano)
		globalJuego.siguiente_oleada() # cambia la oleada a la siguiete
	else:
		print("perdiste, reiniicando la oleada...")
		globalJuego.perder_fe(5)
		



func _ocultar_gano() -> void:
	gano_oleada.visible = false
