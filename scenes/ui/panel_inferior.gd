extends Panel


# panel inferior
@onready var contenedor_piezas =$ContenedorInventario



func _ready():
	_crear_botones_piezas_inventario()
	


# Funcion de botones

func _crear_botones_piezas_inventario() -> void:
	for pieza in globalJuego.piezas_inventario:
		# Crear un botón nuevo
		var boton = Button.new()
		
		# Configurar el texto del botón
		boton.text = pieza["nombre"] 
		
		# Guardar datos de la pieza en el botón (para saber qué torre es)
		boton.set_meta("nombre", pieza["nombre"])
		
		# Conectar la señal de click
		boton.pressed.connect(_on_pieza_clicked.bind(pieza))
		
		# Agregar el botón al contenedor
		contenedor_piezas.add_child(boton)

# logica de botones
func _on_pieza_comprar_clicked(pieza: Dictionary) -> void:
	if globalJuego.monedas >= pieza["precio"]:
		print("✅ Seleccionaste: ", pieza["nombre"])
		print("💰 Precio: ", pieza["precio"])
		globalJuego.comprar_pieza(pieza)
		# SEÑAL AL JUEGO 3D PARA COLOCAR LA PIEZA
		# emit_signal("torre_seleccionada", pieza["tipo"], pieza["precio"])
	else:
		print("❌ No tienes suficiente dinero para ", pieza["nombre"])
		print("💰 Necesitas: ", pieza["precio"], " | Tienes: ", globalJuego.monedas)

func _on_pieza_clicked(pieza: Dictionary) -> void:
	print("clickeando")


func _on_boton_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main.tscn")
