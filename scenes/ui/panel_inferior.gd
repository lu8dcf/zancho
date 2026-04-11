extends CanvasLayer


# panel inferior
@onready var contenedor_piezas =$ContenedorInventario



func _ready():
	# Conectar las señales globales para actualizar la UI automáticamente
	GlobalJuego.monedas_cambiadas.connect(_actualizar_monedas)
	GlobalJuego.vidas_cambiadas.connect(_actualizar_vidas)
	GlobalJuego.oleada_cambiada.connect(_actualizar_oleada)
	#GlobalJuego.tienda_estado_cambiado.connect(_actualizar_tienda)
	
	# Actualizar valores iniciales
	_actualizar_monedas(GlobalJuego.monedas)
	_actualizar_vidas(GlobalJuego.vidas)
	_actualizar_oleada(GlobalJuego.oleada_actual)
	
	_crear_botones_piezas_inventario
	configurar_tienda()

func _actualizar_monedas(nuevas_monedas: int) -> void:
	monedas_label.text = "💰 " + str(nuevas_monedas)

func _actualizar_vidas(nuevas_vidas: int) -> void:
	vidas_label.text = "❤️ " + str(nuevas_vidas) + "/" + str(GlobalJuego.vidaMax)

func _actualizar_oleada(nueva_oleada: int) -> void:
	oleada_label.text = " OLEADA " + str(nueva_oleada)

func configurar_tienda():
	
	
	_crear_botones_piezas_tienda()


# Funcion de botones

func _crear_botones_piezas_tienda() -> void:
	for pieza in GlobalJuego.piezas_disponibles_tienda:
		# Crear un botón nuevo
		var boton = Button.new()
		
		# Configurar el texto del botón
		boton.text = pieza["nombre"] + "\n💰" + str(pieza["precio"])
		
		# Guardar datos de la pieza en el botón (para saber qué torre es)
		boton.set_meta("precio", pieza["precio"])
		boton.set_meta("nombre", pieza["nombre"])
		
		# Conectar la señal de click
		boton.pressed.connect(_on_pieza_comprar_clicked.bind(pieza))
		
		# Agregar el botón al contenedor
		tienda_botones.add_child(boton)

func _crear_botones_piezas_inventario() -> void:
	for pieza in GlobalJuego.piezas_inventario:
		# Crear un botón nuevo
		var boton = Button.new()
		
		# Configurar el texto del botón
		boton.text = pieza["nombre"] 
		
		# Guardar datos de la pieza en el botón (para saber qué torre es)
		boton.set_meta("nombre", pieza["nombre"])
		
		# Conectar la señal de click
		boton.pressed.connect(_on_pieza_clicked.bind(pieza))
		
		# Agregar el botón al contenedor
		tienda_botones.add_child(boton)

func _on_button_tienda_pressed() -> void:
	if tienda_boton.text == " + ":
		tienda_contenido.visible = true
		tienda_boton.position = Vector2(815, 285)
		tienda_boton.text = " - "
	else:
		tienda_contenido.visible = false
		tienda_boton.position = Vector2(1110,285)
		tienda_boton.text = " + "

# logica de botones
func _on_pieza_comprar_clicked(pieza: Dictionary) -> void:
	if GlobalJuego.monedas >= pieza["precio"]:
		print("✅ Seleccionaste: ", pieza["nombre"])
		print("💰 Precio: ", pieza["precio"])
		GlobalJuego.comprar_pieza(pieza)
		# SEÑAL AL JUEGO 3D PARA COLOCAR LA PIEZA
		# emit_signal("torre_seleccionada", pieza["tipo"], pieza["precio"])
	else:
		print("❌ No tienes suficiente dinero para ", pieza["nombre"])
		print("💰 Necesitas: ", pieza["precio"], " | Tienes: ", GlobalJuego.monedas)

func _on_pieza_clicked(pieza: Dictionary) -> void:
	print("clickeando")


func _on_boton_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main.tscn")
