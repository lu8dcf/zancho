extends TextureButton

@export var texto :String
@onready var label: Label = $Label
@export var esconder_idle: CompressedTexture2D
@export var esconder_hover: CompressedTexture2D
@export var mostrar_hover: CompressedTexture2D
@export var mostrar_idle: CompressedTexture2D


var mostrando : bool = true

func _ready() -> void:
	label.text = texto

	pressed.connect(_on_pressed)
	

	texture_normal = mostrar_idle
	texture_hover = mostrar_hover

func _on_pressed() -> void:
	Sonidos.boton1()

	mostrando = !mostrando
	
	if mostrando:
		texture_normal = mostrar_idle
		texture_hover = mostrar_hover
	else:
		texture_normal = esconder_idle
		texture_hover = esconder_hover

func cambiar_texto(texto_nuevo:String) :
	label.text = texto_nuevo
	
func ver_texto():
	return label.text
