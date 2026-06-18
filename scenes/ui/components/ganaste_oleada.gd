extends Control

@onready var ganaste_oleada: Control = $"."


const ESCENA_MONEDA = preload("res://scenes/ui/monedas/mostrar_monedas.tscn")
func _ready() -> void:
	var nueva_moneda = ESCENA_MONEDA.instantiate()
	add_child(nueva_moneda)
	


func _on_continuar_pressed() -> void:
	GlobalJuego.siguiente_oleada()
	$AnimationPlayer.play_backwards("ganaste la oldeada")
	
	#ganaste_oleada.visible = false
	
