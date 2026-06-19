extends Panel

@onready var barra_fe: TextureProgressBar = $BarraFe
@onready var corona: TextureRect = $corona

var tween_corona: Tween
var altura_maxima_corona: float
var altura_minima_corona: float

func _ready() -> void:
	barra_fe.max_value = GlobalJuego.feMax
	barra_fe.value = GlobalJuego.fe
	
	altura_maxima_corona = corona.position.y  # pos cuando la fe está al máximo
	altura_minima_corona = barra_fe.position.y + barra_fe.size.y - corona.size.y 
	
	GlobalJuego.fe_cambiada.connect(_actualizar_fe)
	_actualizar_fe(GlobalJuego.fe)

func _actualizar_fe(fe_nueva):
	barra_fe.value = clamp(fe_nueva, 0, barra_fe.max_value)
	
	var progreso = barra_fe.value / barra_fe.max_value
	
	var nueva_pos_y = lerp(altura_minima_corona, altura_maxima_corona, progreso)
	if tween_corona and tween_corona.is_running():
		tween_corona.kill()
	
	tween_corona = create_tween()
	tween_corona.tween_property(corona, "position:y", nueva_pos_y, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
