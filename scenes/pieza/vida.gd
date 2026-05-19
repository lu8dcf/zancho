extends Node3D

@onready var barraVerde = $vidaverde
var esVisible: bool = false

func _on_pieza_base_barra_vida(porcentaje: float) -> void:
	if (!esVisible):
		esVisible = true
		visible = true
		
	if porcentaje <= 0:
		esVisible = false
		visible = false
	
	if(barraVerde.scale.y > 0):
		barraVerde.scale.y = porcentaje
