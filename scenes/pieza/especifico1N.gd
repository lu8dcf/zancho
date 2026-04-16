extends  Node3D
class_name Peon


func _ready():
	GlobalSignal.connect("marcaPaso",movimiento)
	
func movimiento():
	pass
