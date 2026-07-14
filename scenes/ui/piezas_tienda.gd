extends Panel

@onready var hover: TextureButton = $hover
@onready var pieza: TextureButton = $pieza
@onready var venta: TextureButton = $venta
@onready var compra: TextureButton = $compra

@onready var bloqueos: TextureButton = $bloqueos
@onready var panel_tienda: Panel = $"../../.."

var candado_cerrado = load("res://assets/ui/candado_cerrado.png")
var sin_plata  = load("res://assets/ui/moneda.png")

func _ready() -> void:
	# señales onectadas
	economia.pieza_vendida.connect(actualizar_pieza)
	economia.pieza_comprada.connect(actualizar_pieza)
	
	
	#conectar botones
	venta.pressed.connect(_on_venta_pressed)
	compra.pressed.connect(_on_compra_pressed)
	pieza.mouse_entered.connect(_on_pieza_mouse_entered)
	pieza.mouse_exited.connect(_on_pieza_mouse_exited)

	bloqueos.visible = false
	actualizar_pieza(true)
	economia.connect("monedas_cambiadas", actualizar_pieza)
	GlobalSignal.connect("comienzoOleada", actualizar_pieza)
	#GlobalJuego.connect("oleada_cambiada", actualizar_pieza)
	GlobalSignal.connect("finalizaOleada",actualizar_pieza)
	GlobalSignal.connect("tiendaClick",actualizar_pieza)

	hover.visible =false


func _on_venta_pressed() -> void:
	var nombre_pieza = name  # esto devolverá "Peon"
	if economia.inventario_actual.get(nombre_pieza, 0) > 0:
		economia.vender_pieza(nombre_pieza)
		actualizar_pieza(true)


func _on_compra_pressed() -> void:
	var nombre_pieza = name  # Esto devolverá "Peon"
	# intentar comprar esto ahora verifica: monedas y límites
	if economia.comprar_pieza(nombre_pieza):
		actualizar_pieza(true)
	else:
		print("No se pudo comprar ", nombre_pieza)


func actualizar_pieza(_nada:bool):
	var nombre_pieza  = name  # esto devolverá "Peon"
	var datos = economia.obtener_datos_pieza(nombre_pieza)
	
	# si no hay datos, deshabilitar todo
	if datos.is_empty():
		deshabilitar_todo()
		print("error no hay datos")
		return
	
	# si la oleada empezó, bloquear todo
	
	if GlobalJuego.empezo_oleada:
		deshabilitar_todo_cerrado()
		panel_tienda._ocultar_tienda()
		return
		
	# bloquear si no estan habilitados aun segun su orden de aparición
	if economia.verificar_orden_aparicion(nombre_pieza) and !GlobalJuego.debug:
		deshabilitar_todo_cerrado()
		return
		
		
	elif economia.monedas_actual < datos["precio"]:
		 # Verificar si no hay suficientes monedas
		bloqueos.visible = true
		bloqueos.texture_normal = sin_plata
		pieza.disabled = true
		venta.disabled = inventario_vacio(nombre_pieza)
		compra.disabled = true
		return
		
	elif economia.llego_al_limite(nombre_pieza): # Verificar si llegó al límite
		bloqueos.visible = true
		bloqueos.texture_normal = null
		bloqueos.cambiar_texto("MAX")
		pieza.disabled = true
		venta.disabled = inventario_vacio(nombre_pieza)
		compra.disabled = true
		return
	#  habilitar
	bloqueos.visible = false
	bloqueos.cambiar_texto("")
	bloqueos.texture_normal = null
	pieza.disabled = false
	venta.disabled = inventario_vacio(nombre_pieza)
	compra.disabled = false

func deshabilitar_todo():
	pieza.disabled = true
	venta.disabled = true
	compra.disabled = true
	bloqueos.visible = true


func deshabilitar_todo_cerrado():
	pieza.disabled = true
	venta.disabled = true
	compra.disabled = true
	bloqueos.visible = true
	bloqueos.texture_normal = candado_cerrado

func inventario_vacio(nombre_pieza: String) -> bool:
	return economia.inventario_actual.get(nombre_pieza, 0) <= 0

func _on_pieza_mouse_entered() -> void:
	hover.visible = true

func _on_pieza_mouse_exited() -> void:
	hover.visible =false
