extends MenuBar

@onready var check_button: CheckButton = $multi/CheckButton

func _ready() -> void:
	check_button.disabled = true




func _on_check_button_pressed() -> void:
	Sonidos.error()


func _on_check_button_mouse_entered() -> void:
	Sonidos.error()
