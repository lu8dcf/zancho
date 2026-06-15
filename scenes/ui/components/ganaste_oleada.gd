extends Control

func _ready() -> void:
	GlobalSignal.monedas.emit()
