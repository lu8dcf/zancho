extends Panel

@onready var hover: TextureButton = $hover
@onready var pieza: TextureButton = $pieza
@onready var venta: TextureButton = $venta
@onready var compra: TextureButton = $compra

@onready var bloqueos: TextureButton = $bloqueos

var candado_abierto = load("res://assets/ui/candado_abierto.png")
var candado_cerrado = load("res://assets/ui/candado_cerrado.png")
var sin_plata  = load("res://assets/ui/moneda.png")

func _ready() -> void:
	
	economia.pieza_vendida.connect(actualizar_pieza)
	economia.pieza_comprada.connect(actualizar_pieza)
	venta.pressed.connect(_on_venta_pressed)
	compra.pressed.connect(_on_compra_pressed)
	pieza.mouse_entered.connect(_on_pieza_mouse_entered)
	pieza.mouse_exited.connect(_on_pieza_mouse_exited)
	GlobalSignal.finalizaOleada.connect(actualizar_pieza)

	bloqueos.visible = false
	actualizar_pieza()
	
	hover.visible =false


func _on_venta_pressed() -> void:
	actualizar_pieza()
	var nombre_del_panel = name  # Esto devolverá "Peon"
	var valor = _obtener_valor_reventa(nombre_del_panel)
	var pieza_venta = economia.obtener_pieza_dicc(nombre_del_panel)
	economia.vender_pieza(pieza_venta,valor)


func _on_compra_pressed() -> void:
	actualizar_pieza()
	var nombre_del_panel = name  # Esto devolverá "Peon"
	var pieza_compra = economia.obtener_pieza_dicc(nombre_del_panel)
	if economia.monedas_actual >= pieza_compra["precio"]:
		economia.comprar_pieza(pieza_compra)


func actualizar_pieza(_nada=0):
	var nombre_del_panel = name  # esto devolverá "Peon"
	var pieza_actualizar = economia.obtener_pieza_dicc(nombre_del_panel)
	if globalJuego.empezo_oleada:
		pieza.disabled = true
		venta.disabled = true
		compra.disabled = true
		bloqueos.visible = true
		bloqueos.texture_normal = candado_cerrado
		return
		
	bloqueos.visible = true
	bloqueos.texture_normal = candado_abierto
	if pieza_actualizar["precio"] > economia.monedas_actual:
		pieza.disabled = true
		venta.disabled = false
		compra.disabled = true
		bloqueos.visible = true
		bloqueos.texture_normal = sin_plata
		#print("no te alcanza")
		return
	if economia.llego_al_limite(pieza_actualizar["nombre"], 0):
		bloqueos.visible = true
		bloqueos.texture_normal = null
		bloqueos.cambiar_texto("MAX")
		pieza.disabled = true
		venta.disabled = false
		compra.disabled = true
		#print(pieza_actualizar["nombre"] + "\n" + str(pieza_actualizar["precio"])+ "\n" + "MAX")
		return
	if 	economia.verificar_orden_aparicion(pieza_actualizar["nombre"]) and !globalJuego.debug:
		pieza.disabled = true
		venta.disabled = true
		compra.disabled = true
		bloqueos.visible = true
		bloqueos.texture_normal = candado_cerrado
		#print(pieza_actualizar["nombre"] + "\n" + "DESHABILITADO")
		return
	pieza.disabled = false
	venta.disabled = false
	compra.disabled = false


func _obtener_valor_reventa(nombre_pieza: String) -> int:
	return economia.valor_reventa.get(nombre_pieza, 0)


func _on_pieza_mouse_entered() -> void:
	actualizar_pieza()
	hover.visible = true

func _on_pieza_mouse_exited() -> void:
	hover.visible =false
