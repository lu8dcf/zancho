extends MenuBar

@onready var check_button: CheckButton = $multi/CheckButton
@onready var check_color: CheckButton = $color_piezas/checkColor

var check_color_elegido = true
var pre_check_color = true
func _ready() -> void:
	check_button.disabled = true


func _on_check_button_pressed() -> void:
	Sonidos.error()


func _on_check_button_mouse_entered() -> void:
	Sonidos.error()


func _on_check_color_toggled(toggled_on: bool) -> void:
	check_color_elegido = toggled_on


func _on_guardar_pressed() -> void:
	Piezas.color_piezas = check_color_elegido


func _on_restablecer_pressed() -> void:
	check_color.button_pressed  = pre_check_color
	check_color_elegido = pre_check_color
