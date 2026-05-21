extends Node3D

#clase de pieza
@export var danioA: int
@export var danioD: int
@export var idA: int
@export var idD: int


@export var piezaA_sitio:Vector3
@export var piezaD_sitio:Vector3
# Called when the node enters the scene tree for the first time.

var atacanteId: int
var defensorId: int
var danio: int
var turno = true # true turno inicial atacante A
var mi_timer = Timer
var murio= false # evita que siga atacando la pieza muerta

func _ready() -> void:
	crear_timer()
	GlobalSignal.connect("piezaMuere",piezaMuere) # una pieza murio
	GlobalSignal.connect("finalizaOleada",finalizaOleada)

func _on_timer_timeout():
	if murio: # evita que siga atacando la pieza muerta
		print ("murio")
		return
	# poner el potenciador de daño
	if turno:
		turno = false
		danio = danioA
		atacanteId = idA
		defensorId = idD
		
	else:
		turno = true
		danio = danioD
		atacanteId = idD
		defensorId = idA
		
	GlobalSignal.piezaAtaca.emit(atacanteId)
	GlobalSignal.piezaRecibeDanio.emit(defensorId,danio)
	

func crear_timer(): # Tiempo entre ataques
	mi_timer = Timer.new()
	# Configurar como cíclico (0.5 segundos)
	mi_timer.wait_time = 0.5
	mi_timer.one_shot = false  # false = cíclico / true = una sola vez
	mi_timer.autostart = true   # Inicia automáticamente
	
	# Conectar la señal timeout
	mi_timer.timeout.connect(_on_timer_timeout)
	
	# Agregar a la escena
	add_child(mi_timer)

func piezaMuere(id):
	if id==idA:
		mi_timer.stop()  # detengo el timer de ataque
		GlobalSignal.giro_pieza.emit(idD,1000)	
		murio = true # evita que siga atacando la pieza muerta
		get_parent().eliminar_par(idA,idD)
		queue_free()
		
	if id==idD:
		mi_timer.stop()  # detengo el timer de ataque
		GlobalSignal.giro_pieza.emit(idA,1000)
		murio = true # evita que siga atacando la pieza muerta
		get_parent().eliminar_par(idA,idD)
		queue_free()
	
func finalizaOleada(_estado):
	queue_free()
