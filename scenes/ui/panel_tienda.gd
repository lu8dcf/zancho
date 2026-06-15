extends Panel

# boton  e imagen de la tienda
@onready var imagen_tienda: TextureRect = $ImagenTienda
@onready var boton_de_despliegue: TextureButton = $ImagenTienda/boton_de_despliegue

@onready var panel_tienda: Panel = $"."

var tween: Tween
var tienda_visible: bool = false

# posiciones 
var posicion_oculta : Vector2
var posicion_visible : Vector2
var posicion_boton_visible : Vector2
var posicion_boton_oculta : Vector2

var altura_boton_visible: float = 100  # altura de tamaño de botón

func _ready():
	# Guardar la posición actual como visible
	posicion_visible = imagen_tienda.position
	posicion_oculta = posicion_visible + Vector2(0, imagen_tienda.size.y - altura_boton_visible)
	
	posicion_boton_visible = boton_de_despliegue.position
	posicion_boton_oculta = posicion_boton_visible - Vector2(0, imagen_tienda.size.y - altura_boton_visible)
	
	if Piezas.color_piezas:
		imagen_tienda.texture=preload("res://assets/ui/compra.png")
	else:
		imagen_tienda.texture=preload("res://assets/ui/compra_negro.png")
	boton_de_despliegue.pressed.connect(_alternar_tienda)

	
	imagen_tienda.position = posicion_oculta
	
	GlobalSignal.connect("tiendaHoverParpadea", parpadeaTutorial)
	# Conectar las señales globales para actualizar la UI automáticamente
	#economia.pieza_vendida.connect(_crear_botones_piezas_tienda)
	
	
	#configurar_tienda()

func parpadeaTutorial():

	var tweenParpadeo = create_tween()
	for i in 2:
		tweenParpadeo.tween_property(boton_de_despliegue, "scale", Vector2(.9, 1), 0.1)
		tweenParpadeo.tween_property(boton_de_despliegue, "scale", Vector2.ONE, 0.1)


func _alternar_tienda():
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween()
	
	if tienda_visible:
		_ocultar_tienda()
	else:
		_mostrar_tienda()
	
	tienda_visible = !tienda_visible

func _mostrar_tienda():
	Sonidos.boton1()
	
	GlobalSignal.emit_signal("tiendaClick")
	
	# Efecto de rebote al mostrar
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)  # BACK crea el efecto rebote
	
	tween.tween_property(imagen_tienda, "position", posicion_visible, 0.6)
	
	

func _ocultar_tienda():
	# Efecto suave al ocultar (sin rebote, más rápido)
	if not tween or not is_instance_valid(tween) or not tween.is_valid():
		tween = create_tween()
	else:
		# Si hay un tween corriendo, lo matamos
		if tween.is_running():
			tween.kill()
		tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	
	tween.tween_property(imagen_tienda, "position", posicion_oculta, 0.4)
	
