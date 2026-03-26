extends Area3D

# velocidad de la rotacion por segundo de la moneda
const ROTACION_VELOCIDAD = 2

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	
	rotate_y(deg_to_rad(ROTACION_VELOCIDAD)) #se transforma un valor en grados
	
	#if has_overlapping_bodies(): # de esta forma detecta al jugador y desaparece la modena
		#queue_free()
		

func _on_body_entered(body: Node3D) -> void:
	queue_free()
	
	
	
