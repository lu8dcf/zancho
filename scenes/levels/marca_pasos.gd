extends Timer
class_name MarcaAtaque



func _ready():
	# inicializar 
	wait_time = GlobalJuego.tiempo_pasos  # duracion
	one_shot = false  # Repetitivo (ciclos infinitos)
	autostart = false  # No inicia solo, control manual
	
	# Conectar la señal timeout a una función
	timeout.connect(_on_mi_timer_timeout)

	#Señal de control
	GlobalSignal.connect("controlMarcaPaso",control)
	# Señal de cambio de velocidad
	GlobalSignal.connect("aceleraMarcaPaso",multiplicador)

func _on_mi_timer_timeout():
	if GlobalJuego.ataque_en_proceso:
		return
	GlobalSignal.marcaPaso.emit() # Señal que marcara a las piezas ejecucion del paso
	

# Función para controlar false true
func control(activa):
	
	if activa:
		start()
		if GlobalJuego.ataque_en_proceso:
			return
		GlobalSignal.marcaPaso.emit() # Señal que marcara a las piezas ejecucion del paso
	else:
		stop()
		
func multiplicador(multi):
	if multi < 1 or multi >5:
		return
	#wait_time = GlobalJuego.tiempo_pasos / multi


	var escala = float(multi) * 0.75  # 1=1.0 (100%), 2=1.5 (150%), ..., 5=4.0 (400%)
	Engine.time_scale = escala
