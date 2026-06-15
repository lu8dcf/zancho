extends Control


const ESCENA_MONEDA = preload("res://scenes/ui/monedas/mostrar_monedas.tscn")
func _ready() -> void:
	var nueva_moneda = ESCENA_MONEDA.instantiate()
	add_child(nueva_moneda)
