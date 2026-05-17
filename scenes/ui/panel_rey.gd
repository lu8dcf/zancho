extends Panel
@onready var barra_fe: TextureProgressBar = $BarraFe

func _ready() -> void:
	barra_fe.max_value = globalJuego.feMax
	barra_fe.value = globalJuego.fe
	
	globalJuego.fe_cambiada.connect(_actualizar_fe)
	
	#globalJuego.tienda_estado_cambiado.connect(_actualizar_tienda)
	
	_actualizar_fe(globalJuego.fe)
	
	
func _actualizar_fe(fe_nueva):
	barra_fe.value = clamp(fe_nueva, 0, barra_fe.max_value)
