extends Node3D

var pares_almacenados = {}


const ATAQUE_BASE = preload("res://scenes/levels/ataque/ataque_base.tscn")

func _ready() -> void:
	limpiar_todo()
	GlobalSignal.connect("ataque",iniciaAtaque)
	GlobalSignal.connect("finalizaOleada",finalizaOleada)
	
# A= Atacante  , D= defensor
func iniciaAtaque(idA,idD,posicionA,posicionD,tipoA,tipoD):
	if vive(idA)==false:return # aseguramos que estan las piezas vivas
	if vive(idD)==false:return
	
	if _crear_clave(idA, idD)==false:  # codigo del ataque y verifica que no eista anterirormente
		return
	#print (idA," ",idD," ",posicionA," ",posicionD)
	GlobalSignal.controlMarcaPaso.emit(false) #detiene el paso del juego
	Sonidos.ataque()
	angulo_enfrentamiento(idA,posicionA,posicionD)
	angulo_enfrentamiento(idD,posicionD,posicionA)
	
	var nuevo_ataque = ATAQUE_BASE.instantiate() # Crea el ataque
			
	nuevo_ataque.idA = idA
	nuevo_ataque.idD = idD
	nuevo_ataque.danioA = calcular_danio(tipoA,tipoD)
	nuevo_ataque.danioD = calcular_danio(tipoD,tipoA)
	nuevo_ataque.tipoA = tipoA
	nuevo_ataque.tipoD = tipoD
			
	add_child(nuevo_ataque)
	
func calcular_danio(tipoA,tipoD): # Calcula el daño qu epuede generar en la diferentes piezas con su potenciador
	var danio= Piezas.danio[tipoA]
	if Piezas.bonus_a[tipoA]==tipoD:
		danio = Piezas.bonus_cantidad[tipoA] * danio
	return danio	
	
func _crear_clave(a, d): # Genera una clave única que ignora el orden
	var clave = _generar_clave(a, d)
	if not pares_almacenados.has(clave):
		if pieza_en_batalla(a,d):
			return false #a espera
		#print (" batalla directa ",clave)
		pares_almacenados[clave] = {"a": a,"d": d}
		return true  # Se almacenó
	return false  # Ya existía

func _generar_clave(a: int, d: int) -> String: # Genera una clave única que ignora el orden
	# Ordenamos los números para que (1,2) y (2,1) generen la misma clave
	var menor = min(a, d)
	var mayor = max(a, d)
	return str(menor) + "|" + str(mayor)

func pieza_en_batalla(a,d): # compara la nueva batalla si los componente ya estan en otra 
	for clave in pares_almacenados:
		var claves = pares_almacenados[clave]
		var a_guardado = claves["a"]
		var d_guardado = claves["d"]
		if a==a_guardado or a==d_guardado or d==a_guardado or d==d_guardado:
			return true
	return false
	
## Elimina un par específico
func eliminar_par(a: int, b: int):
	var clave = _generar_clave(a, b)
	if pares_almacenados.has(clave):
		pares_almacenados.erase(clave)
		contar_pares()
		#print ("contar pares",a," ",b)
	return false
	
## Cuenta cuántos pares únicos hay
func contar_pares():
	if pares_almacenados.size() == 0:
		GlobalSignal.controlMarcaPaso.emit(true)

## Limpia todos los pares
func limpiar_todo():
	pares_almacenados.clear()

func angulo_enfrentamiento(id,posicionA: Vector3,posicionD: Vector3):
	var posA = posicionA/ GlobalJuego.espaciado_baldosas
	var posD = posicionD/ GlobalJuego.espaciado_baldosas 
	var giro=(atan2(posD.z - posA.z, posA.x - posD.x)) # calculo del angulo, de ataque Deltaay y -deltaX
	GlobalSignal.giro_pieza.emit(id,giro)
	
func finalizaOleada(estado):
	limpiar_todo()  # limpia todas las batallas
	GlobalSignal.controlMarcaPaso.emit(false) # parar el marca paso
	Piezas.pieza_negra=[]  # eliminar la lista de instancia
	
	if estado:
		economia.piezas_vivas=[] # limpio la lista anterior
		for pieza in Piezas.pieza_blanca: # recorro las piezas que quedaron vivas
			economia.piezas_vivas.append(pieza.pieza_tipo) # agrego el numero de pieza
		economia.piezas_vivas.remove_at(0)  # elimino la primer ubicación que es el rey
	Piezas.pieza_blanca=[]  # eliminar la lista de instancia
	# tiempo de espera para que se limpie el ataque
	
	await get_tree().create_timer(2.0).timeout
	
	GlobalSignal.nuevaOleada.emit(estado)
	
func vive(id): # detector de que la pieza sigue en instancia, evitar que ataue al morir
	for pieza in Piezas.pieza_blanca:
		if pieza.id == id:
			return true
	for pieza in Piezas.pieza_negra:
		if pieza.id == id:
			return true
	return false
