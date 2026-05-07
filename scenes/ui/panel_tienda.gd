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
	
	boton_de_despliegue.pressed.connect(_alternar_tienda)

	
	imagen_tienda.position = posicion_oculta
	
	
	# Conectar las señales globales para actualizar la UI automáticamente
	#economia.pieza_vendida.connect(_crear_botones_piezas_tienda)
	
	
	#configurar_tienda()


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
	# Efecto de rebote al mostrar
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)  # BACK crea el efecto rebote
	
	tween.tween_property(imagen_tienda, "position", posicion_visible, 0.6)
	
	

func _ocultar_tienda():
	# Efecto suave al ocultar (sin rebote, más rápido)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	
	tween.tween_property(imagen_tienda, "position", posicion_oculta, 0.4)
	
	

#func configurar_tienda():
	#_crear_botones_piezas_tienda()
#
#
##
## Funcion de botones
#func _crear_botones_piezas_tienda() -> void:
	#for hijo in tienda_botones.get_children():
		#hijo.queue_free()
	#
	#for pieza in economia.piezas_disponibles_tienda:
		## Crear un botón nuevo
		#var boton = Button.new()
		#
		## Configurar el texto del botón
		#boton.text = pieza["nombre"] + "\n💰" + str(pieza["precio"])
		#
		## Guardar datos de la pieza en el botón (para saber qué torre es)
		#boton.set_meta("precio", pieza["precio"])
		#boton.set_meta("nombre", pieza["nombre"])
		#
		#
		## Configurar tamaño mínimo para uniformidad
		#boton.custom_minimum_size = Vector2(120, 60)
		#
		## Añadir margen interno al botón (padding)
		#boton.add_theme_constant_override("outline_size", 0)
		#
		## Conectar la señal de click
		#boton.pressed.connect(_on_pieza_comprar_clicked.bind(pieza))
		#if pieza["precio"] > economia.monedas_actual:
			#boton.disabled = true
		#if economia.llego_al_limite(pieza["nombre"], 0):
			#boton.disabled = true
			#boton.text = pieza["nombre"] + "\n" + str(pieza["precio"])+ "\n" + "MAX"
		#if 	economia.verificar_orden_aparicion(pieza["nombre"]) and !globalJuego.debug:
			#boton.disabled = true
			#boton.text = pieza["nombre"] + "\n" + "DESHABILITADO"
#
		## Agregar el botón al contenedor
		#tienda_botones.add_child(boton)
#
#
#
## logica de botones
#func _on_pieza_comprar_clicked(pieza: Dictionary) -> void:
	#if economia.monedas_actual >= pieza["precio"]:
		#economia.comprar_pieza(pieza)
		## SEÑAL AL JUEGO 3D PARA COLOCAR LA PIEZA
		## emit_signal("torre_seleccionada", pieza["tipo"], pieza["precio"])
		#_crear_botones_piezas_tienda()
		#


func _on_boton_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main.tscn")
