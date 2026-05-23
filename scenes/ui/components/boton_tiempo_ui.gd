extends TextureButton

@onready var selectordevelocidad: TextureButton = $"../selectordevelocidad"

@export var texto :String
# Variables para ajustar el desfasaje en píxeles desde el inspector
var offset_x : float = -1
var offset_y : float = 3

@onready var label: Label = $Label

func _ready() -> void:
	label.text = texto
	
	# Aseguramos que el selector arranque invisible al iniciar el juego
	if selectordevelocidad:
		selectordevelocidad.visible = false
		
	# Conectamos la señal pressed
	pressed.connect(_on_self_pressed)

func _on_self_pressed() -> void:
	if selectordevelocidad:
		# Calculamos la nueva posición sumando los offsets configurados
		var nueva_posicion = Vector2(
			global_position.x + offset_x,
			global_position.y + offset_y
		)
		
		# Copia la posición ajustada y lo hace visible
		selectordevelocidad.global_position = nueva_posicion
		selectordevelocidad.visible = true

func cambiar_texto(texto_nuevo:String) :
	label.text = texto_nuevo

func ver_texto():
	return label.text
