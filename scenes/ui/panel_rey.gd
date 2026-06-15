extends Panel
@onready var barra_fe: TextureProgressBar = $BarraFe

func _ready() -> void:
	barra_fe.max_value = GlobalJuego.feMax
	barra_fe.value = GlobalJuego.fe
	
	GlobalJuego.fe_cambiada.connect(_actualizar_fe)
	
	#GlobalJuego.tienda_estado_cambiado.connect(_actualizar_tienda)
	
	_actualizar_fe(GlobalJuego.fe)
	
	
func _actualizar_fe(fe_nueva):
	barra_fe.value = clamp(fe_nueva, 0, barra_fe.max_value)
