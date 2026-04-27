# BotonPiezaInventario.gd
extends Button
class_name BotonPiezaInventario

# Señales
signal pieza_seleccionada(pieza_data: Dictionary)
signal cancelar_colocacion

# Referencias
@onready var subviewport_container = $SubViewportContainer
@onready var subviewport = $SubViewportContainer/SubViewport
@onready var pieza_preview = $SubViewportContainer/SubViewport/PiezaPreview
@onready var label_cantidad = $LabelCantidad
@onready var boton_cancelar = $BotonCancelar
@onready var indicador_seleccion = $IndicadorSeleccion

var pieza_data: Dictionary = {}
var esta_seleccionada: bool = false
var modo_colocacion_activo: bool = false

func setup(pieza: Dictionary):
	pieza_data = pieza
	
	# Configurar texto
	text = ""
	
	# Cargar preview 3D
	var tipo = _obtener_tipo_por_nombre(pieza["nombre"])
	if pieza_preview:
		pieza_preview.cargar_modelo(tipo)
	
	# Configurar cantidad
	if label_cantidad:
		label_cantidad.text = str(pieza["cantidad"]) + "/" + str(economia.limite_piezas.get(pieza["nombre"], 0))
	
	# Estado inicial
	actualizar_estado()

func _obtener_tipo_por_nombre(nombre: String) -> int:
	var tipos = {
		"Peon": 1,
		"Alfil": 2,
		"Torre": 3,
		"Caballo": 4,
		"Reina": 5
	}
	return tipos.get(nombre, 0)

func actualizar_estado():
	var cantidad = pieza_data.get("cantidad", 0)
	
	if cantidad <= 0:
		disabled = true
		modulate = Color(0.5, 0.5, 0.5, 1)
		if subviewport_container:
			subviewport_container.modulate = Color(0.5, 0.5, 0.5, 1)
	else:
		disabled = false
		if esta_seleccionada:
			modulate = Color(1.2, 1.2, 0.8, 1)  # Dorado para seleccionado
		else:
			modulate = Color(1, 1, 1, 1)
		
		if subviewport_container:
			subviewport_container.modulate = Color(1, 1, 1, 1)
	
	if label_cantidad:
		label_cantidad.text = str(cantidad) + "/" + str(economia.limite_piezas.get(pieza_data["nombre"], 0))

func _on_pressed():
	if disabled:
		return
	
	esta_seleccionada = !esta_seleccionada
	
	if esta_seleccionada:
		seleccionar_pieza()
	else:
		deseleccionar_pieza()

func seleccionar_pieza():
	# Cancelar modo colocación previo si existe
	if Piezas.modo_colocacion:
		Piezas.cancelar_modo_colocacion()
	
	# Iniciar modo colocación
	var tipo = _obtener_tipo_por_nombre(pieza_data["nombre"])
	Piezas.iniciar_modo_colocacion(tipo, pieza_data["nombre"])
	
	# Mostrar botón cancelar
	if boton_cancelar:
		boton_cancelar.visible = true
	
	# Feedback visual
	modulate = Color(1.2, 1.2, 0.8, 1)
	if indicador_seleccion:
		indicador_seleccion.visible = true
	
	pieza_seleccionada.emit(pieza_data)

func deseleccionar_pieza():
	Piezas.cancelar_modo_colocacion()
	
	if boton_cancelar:
		boton_cancelar.visible = false
	
	modulate = Color(1, 1, 1, 1)
	if indicador_seleccion:
		indicador_seleccion.visible = false

func _on_boton_cancelar_pressed():
	deseleccionar_pieza()
	cancelar_colocacion.emit()

func _on_modo_colocacion_cancelado():
	esta_seleccionada = false
	if boton_cancelar:
		boton_cancelar.visible = false
	modulate = Color(1, 1, 1, 1)
	if indicador_seleccion:
		indicador_seleccion.visible = false

func _ready():
	pressed.connect(_on_pressed)
	if boton_cancelar:
		boton_cancelar.pressed.connect(_on_boton_cancelar_pressed)
		boton_cancelar.visible = false
	
	Piezas.modo_colocacion_cancelado.connect(_on_modo_colocacion_cancelado)
