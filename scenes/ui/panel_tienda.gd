extends Panel


# panel de la tienda
@onready var texto = $Label
@onready var tienda_botones = $ContenedorTienda
@onready var monedas_label = $monedas

func _ready():
	# Conectar las señales globales para actualizar la UI automáticamente
	GlobalJuego.monedas_cambiadas.connect(_actualizar_monedas)
	
	
	# Actualizar valores iniciales
	_actualizar_monedas(GlobalJuego.monedas)
	
	configurar_tienda()

func _actualizar_monedas(nuevas_monedas: int) -> void:
	monedas_label.text = "💰 " + str(nuevas_monedas)

func configurar_tienda():
	espaciado()
	_crear_botones_piezas_tienda()

func espaciado():
	# Configurar espaciado para tienda
	if tienda_botones and tienda_botones is GridContainer:
		# Espaciado horizontal y vertical entre botones
		tienda_botones.add_theme_constant_override("h_separation", 15)
		tienda_botones.add_theme_constant_override("v_separation", 15)

# Funcion de botones

func _crear_botones_piezas_tienda() -> void:
	for hijo in tienda_botones.get_children():
		hijo.queue_free()
	
	for pieza in GlobalJuego.piezas_disponibles_tienda:
		# Crear un botón nuevo
		var boton = Button.new()
		
		# Configurar el texto del botón
		boton.text = pieza["nombre"] + "\n💰" + str(pieza["precio"])
		
		# Guardar datos de la pieza en el botón (para saber qué torre es)
		boton.set_meta("precio", pieza["precio"])
		boton.set_meta("nombre", pieza["nombre"])
		
		
		# Configurar tamaño mínimo para uniformidad
		boton.custom_minimum_size = Vector2(120, 60)
		
		# Añadir margen interno al botón (padding)
		boton.add_theme_constant_override("outline_size", 0)
		
		# Conectar la señal de click
		boton.pressed.connect(_on_pieza_comprar_clicked.bind(pieza))
		
		# Agregar el botón al contenedor
		tienda_botones.add_child(boton)

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
