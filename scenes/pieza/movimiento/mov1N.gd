extends  Node3D
class_name Peon


func _ready():
	GlobalSignal.connect("marcaPaso",movimiento)
	
func movimiento():
	print ("peon")
	if not owner: 
		
		return
	
	# Ejemplo: mover hacia adelante según cadencia y tipo
	var paso = Vector3(1, 0, 1) 
	owner.global_position += paso * globalJuego.espaciado_baldosas
	print (owner.global_position)

func animacion():
	var tween = create_tween()
	tween.tween_property(owner, "global_position", owner.global_position + Vector3(0,0,owner.cadencia), 0.5)

	
