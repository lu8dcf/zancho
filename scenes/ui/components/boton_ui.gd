extends TextureButton



@export var texto :String

@onready var label: Label = $Label


func _ready() -> void:

	label.text = texto



func cambiar_texto(texto_nuevo:String) :

	label.text = texto_nuevo


func ver_texto():

	return label.text


func _on_pressed() -> void:
	if self.name == "compra":
		Sonidos.compra()
	elif self.name == "venta":
		Sonidos.venta()
	else:
		Sonidos.boton1()
