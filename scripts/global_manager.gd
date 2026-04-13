extends Node

var lista_turnos : Array = []
var indicador : int = 0 #por donde vamos en la lista
#var pj_activo : Node = null #este es el persojane activo, que le toca el turno
@export var player : Node

#prueba y testeo
var enemigos_falsos = ["Enemigo A", "Enemigo B"]
var player_falso = "Jugador"
var vidasDelRey = 2
var detener : bool = false
var pj_activo : String = ""
var nro_ronda : int = 0

func _ready():
	inicializar_combate()
	
func inicializar_combate():
	actualizar_lista_enemigos()
	armar_cola_turnos()
	iniciar_siguiente_turno()
	
func actualizar_lista_enemigos(): #por si spawnean mas
	#var enemigos = get_tree().get_nodes_in_group("enemigo")
	var enemigos = enemigos_falsos #TESTEO
	return enemigos

func armar_cola_turnos():
	lista_turnos.clear()
	
	#var enemigos = actualizar_lista_enemigos()
	
	#lista_turnos.append(player) #primero el player
	lista_turnos.append(player_falso) #TESTEO
	
	var enemigos = enemigos_falsos.duplicate() #TESTEO (no modifco original)
	enemigos.shuffle() #TESTEO + uso de random
	
	for e in enemigos: #TESTEo (debe ser enemigo)
		#pick random
		lista_turnos.append(e) #loego los esbirros
	indicador = 0
	print("--- ORDEN DE TURNOS ---")
	for t in lista_turnos:
		print(t)
	print("---------------------")


func iniciar_siguiente_turno():
	if detener:
		return
	if lista_turnos.is_empty():
		return
	
	pj_activo = lista_turnos[indicador]
	print("turno de: ", pj_activo)

	if pj_activo == player_falso: #TESTEO
	#if pj_activo.is_in_group("player"):
		#pj_activo.iniciar_turno() #definir dentro de player Y usar señal para que funcione el await
		await iniciar_turno_jugador()
	else:
		#await pj_activo.iniciar_turno() #definir funcion en el enemigo
		await iniciar_turno_enemigo(pj_activo)
	finalizar_turno()

func iniciar_turno_jugador(): #TESTEO
	print("Jugador hace X movimiento")
	await get_tree().create_timer(1.5).timeout
	print ("El jugador pasa el turno!")
	
func iniciar_turno_enemigo(enemigo): #TESTEO
	print("enemigo hace X movimiento")
	await get_tree().create_timer(1.5).timeout
	print ("Cada paso mas cerca del rey, ", enemigo ," pasa el turno!")


func finalizar_turno():
	indicador += 1
	
	if indicador >= lista_turnos.size():
		indicador = 0
		on_nueva_ronda() 

	iniciar_siguiente_turno()
	

func on_nueva_ronda():
	nro_ronda += 1
	vidasDelRey -= 1 #TESTEO
	# spawnear_enemigo()
	if (vidasDelRey <= 0):
		detener_turnero()
		return
	else:
		print("Nueva ronda")
	#actualizar fila
		armar_cola_turnos()
	
func detener_turnero():
	detener = true
	print("El rey fue derrocado")
	print("Numeros de ronda: ", nro_ronda)
	nro_ronda = 0
