extends Node3D

# 1. Precargar la escena (fuera de la función para mejor rendimiento)
var hud_escena = preload("res://scenes/ui/hud.tscn")

func _ready() -> void:
	# 2. Instanciar el nodo
	var hud = hud_escena.instantiate()
	# 4. Añadir al árbol de escenas (necesario)
	add_child(hud)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
