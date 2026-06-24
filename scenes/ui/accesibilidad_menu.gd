extends MenuBar

@onready var check_button: CheckButton = $multi/CheckButton
@onready var option_color: OptionButton = $color_piezas/option_color
@onready var tamanio: OptionButton = $tamanio_mouse/tamanio


var color_elegido = true
var pre_color = true
var tamanio_elegido = 0
func _ready() -> void:
	check_button.disabled = true


func _on_check_button_pressed() -> void:
	Sonidos.error()


func _on_check_button_mouse_entered() -> void:
	Sonidos.error()

func _on_guardar_pressed() -> void:
	
	Piezas.color_piezas = color_elegido
	$"../..".esconder_todo()


func _on_restablecer_pressed() -> void:
	option_color.select(0)
	_on_tamanio_item_selected(0)
	color_elegido = pre_color


func _on_option_color_item_selected(index: int) -> void:
	if index == 0:
		color_elegido = true
	else:
		color_elegido = false


func _on_tamanio_item_selected(index: int) -> void:
	tamanio_elegido = index
	match  index:
		0:
			Cursores.escala_pequeña()
		1:
			Cursores.escala_normal()
		2:
			Cursores.escala_grande()
		3:
			Cursores.escala_muy_grande()
	#Cursores.cambiar_escala_cursor(index)
