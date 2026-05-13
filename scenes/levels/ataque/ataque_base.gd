extends Node3D

#clase de pieza
@export var piezaA_tipo: int
@export var piezaD_tipo: int
@export var idA: int
@export var idD: int

var danioA=Piezas
@export var piezaA_sitio:Vector3
@export var piezaD_sitio:Vector3
# Called when the node enters the scene tree for the first time.

var atacanteId: int
var danio: int
var turno = true # true turno inicial atacante A
var tiempo_ataque = Timer

func _ready() -> void:
	crear_timer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func atacaPieza():
	if turno:
		turno = false
		danio = Piezas.danio[piezaA_tipo]
		GlobalSignal.piezaAtaca.emit(idA)
		GlobalSignal.piezaRecibeDanio.emit(idD,danio)
	else:
		turno = true
		danio = Piezas.danio[piezaA_tipo]
		GlobalSignal.piezaAtaca.emit(idA)
		GlobalSignal.piezaRecibeDanio.emit(idD,danio)

func atacaA():
	pass

func crear_timer():
	# Crear el Timer
	mi_timer = Timer.new()
	
	# Configurar como cíclico (0.5 segundos)
	mi_timer.wait_time = 0.5
	mi_timer.one_shot = false  # false = cíclico / true = una sola vez
	mi_timer.autostart = true   # Inicia automáticamente
	
	# Conectar la señal timeout
	mi_timer.timeout.connect(_on_timer_timeout)
	
	# Agregar a la escena
	add_child(mi_timer)
