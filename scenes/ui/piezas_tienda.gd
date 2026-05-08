extends Panel

@onready var hover: TextureButton = $hover
@onready var pieza: TextureButton = $pieza
@onready var venta: TextureButton = $venta
@onready var compra: TextureButton = $compra

func _ready() -> void:
	
	hover.visible =false
	economia.pieza_vendida.connect(actualizar_pieza)
	economia.pieza_comprada.connect(actualizar_pieza)
	venta.pressed.connect(_on_venta_pressed)
	compra.pressed.connect(_on_compra_pressed)
	pieza.mouse_entered.connect(_on_pieza_mouse_entered)
	pieza.mouse_exited.connect(_on_pieza_mouse_exited)


func _on_venta_pressed() -> void:
	var nombre_del_panel = name  # Esto devolverá "Peon"
	print(nombre_del_panel)
	var valor = _obtener_valor_reventa(nombre_del_panel)
	var pieza_venta = economia.obtener_pieza_dicc(nombre_del_panel)
	economia.vender_pieza(pieza_venta,valor)


func _on_compra_pressed() -> void:
	var nombre_del_panel = name  # Esto devolverá "Peon"
	print(nombre_del_panel)
	var pieza_compra = economia.obtener_pieza_dicc(nombre_del_panel)
	if economia.monedas_actual >= pieza_compra["precio"]:
		economia.comprar_pieza(pieza_compra)


func actualizar_pieza():
	var nombre_del_panel = name  # Esto devolverá "Peon"
	print(nombre_del_panel)
	var pieza_actualizar = economia.obtener_pieza_dicc(nombre_del_panel)
	if pieza_actualizar["precio"] > economia.monedas_actual:
		pieza.disabled = true
		venta.disabled = false
		compra.disabled = true
		print("no te alcanza")
	if economia.llego_al_limite(pieza_actualizar["nombre"], 0):
		pieza.disabled = true
		venta.disabled = false
		compra.disabled = true
		print(pieza_actualizar["nombre"] + "\n" + str(pieza_actualizar["precio"])+ "\n" + "MAX")
	if 	economia.verificar_orden_aparicion(pieza_actualizar["nombre"]) and !globalJuego.debug:
		pieza.disabled = true
		venta.disabled = true
		compra.disabled = true
		print(pieza_actualizar["nombre"] + "\n" + "DESHABILITADO")


func _obtener_valor_reventa(nombre_pieza: String) -> int:
	return economia.valor_reventa.get(nombre_pieza, 0)


func _on_pieza_mouse_entered() -> void:
	hover.visible = true

func _on_pieza_mouse_exited() -> void:
	hover.visible =false
