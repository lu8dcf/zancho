extends PiezaBase
class_name Peon


func _ready():
	GlobalSignal.connect("marcaPaso",movimiento)

func movimiento():
	pass
