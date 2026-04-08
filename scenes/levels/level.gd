extends Node3D

# 1. Precargar la escena (fuera de la función para mejor rendimiento)
var hud_escena = preload("res://scenes/ui/hud.tscn")

func _ready() -> void:
	
	var hud = hud_escena.instantiate()
	add_child(hud)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
