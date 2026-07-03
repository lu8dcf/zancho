extends Timer
class_name MarcaAtaque

var piezas_moviendo=false # indicador de piezas en movimeinto
var cambio=false  # indicador de cambio de velocidad
var activa_reserva: int

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
	bloquear_cambio_velocidad()
	
func bloquear_cambio_velocidad():
	piezas_moviendo=true
	await get_tree().create_timer(GlobalJuego.tiempo_pasos/2).timeout
	piezas_moviendo=false
	if cambio:
		cambio=false
		control(activa_reserva)	

# Función para controlar false true
func control(activa):
	
	if piezas_moviendo:
		cambio=true
		activa_reserva=activa
		return
	
	if activa:
		start()
		if GlobalJuego.ataque_en_proceso:
			return
		GlobalSignal.marcaPaso.emit() # Señal que marcara a las piezas ejecucion del paso
	else:
		stop()
		
func multiplicador(multi):
	if multi < 1 or multi >8:
		return
	#wait_time = GlobalJuego.tiempo_pasos / multi


	var escala = float(multi) * 0.5  # 1=1.0 (100%), 2=1.5 (150%), ..., 5=4.0 (400%)
	Engine.time_scale = escala
