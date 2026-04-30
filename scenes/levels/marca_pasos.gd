extends Timer
class_name MarcaPaso


func _ready():
	# inicializar 
	wait_time = globalJuego.tiempo_pasos  # duracion
	one_shot = false  # Repetitivo (ciclos infinitos)
	autostart = false  # No inicia solo, control manual
	
	# Conectar la señal timeout a una función
	timeout.connect(_on_mi_timer_timeout)

	#Señal de control
	GlobalSignal.connect("controlMarcaPaso",control)
	# Señal de cambio de velocidad
	GlobalSignal.connect("velocidadMarcaPaso",multiplicador)

func _on_mi_timer_timeout():
	GlobalSignal.marcaPaso.emit() # Señal que marcara a las piezas ejecucion del paso
	

# Función para controlar false true
func control(activa):
	
	if activa:
		start()
		
	else:
		stop()
		
func multiplicador(multi):
	if multi < 1 or multi >5:
		return
	wait_time = globalJuego.tiempo_pasos / multi
