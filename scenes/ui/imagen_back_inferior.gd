extends TextureRect

@onready var boton_esconder_inferior: TextureButton = $botonEsconderInferior
@onready var imagen_inferior: TextureRect = $imagenInferior
@onready var panel_inferior: Panel = $"../PanelInferior" # las manchas negras detras de las piezas
@onready var imagen_back_inferior: TextureRect = $"."

var tween: Tween
var panel_visible: bool = true

# posiciones 
var posicion_oculta : Vector2
var posicion_visible : Vector2
var posicion_boton_visible : Vector2
var posicion_boton_oculta : Vector2

var altura_boton_visible: float = 50  # altura de tamaño de botón


func _ready() -> void:
	posicion_visible = imagen_back_inferior.position
	posicion_oculta = posicion_visible + Vector2(0, imagen_back_inferior.size.y - altura_boton_visible)
	
	posicion_boton_visible = boton_esconder_inferior.position
	posicion_boton_oculta = posicion_boton_visible - Vector2(0, imagen_back_inferior.size.y - altura_boton_visible)
	
	
	#imagen_back_inferior.position = posicion_oculta
	



func _on_boton_esconder_inferior_pressed() -> void:
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween()
	
	if panel_visible:
		_ocultar()
	else:
		_mostrar()
	
	panel_visible = !panel_visible


func _mostrar():
	# Efecto de rebote al mostrar
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)  # BACK crea el efecto rebote
	panel_inferior.visible = true
	panel_inferior.modulate.a = 0
	tween.tween_property(imagen_back_inferior, "position", posicion_visible, 0.6)
	tween.parallel().tween_property(panel_inferior, "modulate:a", 1.0, 2.6)
	

func _ocultar():
	# Efecto suave al ocultar (sin rebote, más rápido)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	
	tween.tween_property(imagen_back_inferior, "position", posicion_oculta, 0.4)
	tween.parallel().tween_property(panel_inferior, "modulate:a", 0.0, 0.2)
	
	# Ocultar al finalizar
	await tween.finished
	panel_inferior.visible = false
