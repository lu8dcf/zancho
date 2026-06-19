extends Node

#var monedas_actual : int = 1200 # monedas inicial para la Oleada 1
const NOMBRES_PIEZAS = ["Peon", "Alfil","Torre",  "Caballo", "Reina"]

var inventario_actual: Dictionary = {}
var piezas_colocadas: Dictionary = {}
var piezas_vivas: Array = []

var datos_piezas = {
	"Peon": {
		"precio": 100,
		"valor_reventa": 50,
		"limite": 8,
		"orden_aparicion": 1
	},
	"Torre": {
		"precio": 500,
		"valor_reventa": 250,
		"limite": 2,
		"orden_aparicion": 3
	},
	"Alfil": {
		"precio": 300,
		"valor_reventa": 150,
		"limite": 2,
		"orden_aparicion": 2
	},
	"Caballo": {
		"precio": 350,
		"valor_reventa": 175,
		"limite": 2,
		"orden_aparicion": 4
	},
	"Reina": {
		"precio": 1200,
		"valor_reventa": 600,
		"limite": 1,
		"orden_aparicion": 5
	}
}

# monedas
var monedas_antes_oleada : int = 0 # por si pierde la oleada se resetea a las monedas antesriormente gastadas

var monedas_actual: int = 0 # la cantidad actual
var monedas_objetivo: int = 0 # la cantidad a sumar
var monedas_visuales: int = 0 # lo que ve el usuario
var tween_contador: Tween # para simular el contador



# señales para modificar el hud
signal monedas_cambiadas(nuevas_monedas: int) # Emite el cambio de moneda
signal pieza_comprada(pieza:Dictionary)  # Emite la pieza comprada
signal inventario_actualizado(inventario:Dictionary) # Emite el inventario actualizado
signal pieza_vendida()

func _ready() -> void:
	GlobalSignal.cambioLugar.connect(_agregar_pieza_cambiada)

	reiniciar_variables()


func reiniciar_variables():
	if(GlobalJuego.tutorial):
		monedas_actual = 200
	else:
		monedas_actual = 1200 
	monedas_antes_oleada  = 0
	
	# inicializar los diccionarios
	inicializar_diccionarios()
	economia.emit_signal("inventario_actualizado")

func vacioVariables():
	inventario_actual = {}
	piezas_colocadas = {}
	piezas_vivas = []
	reiniciar_variables()

func inicializar_diccionarios():
	inventario_actual.clear()
	piezas_colocadas.clear()
	
	for nombre in NOMBRES_PIEZAS:
		inventario_actual[nombre] = 0
		piezas_colocadas[nombre] = 0
		
func añadir_monedas(cantidad: int, con_animacion: bool = true) -> void:
	monedas_actual += cantidad
	
	if con_animacion:
		_iniciar_conteo_animado()
	else:
		# Para debug o cuando no quieras animación
		monedas_visuales = monedas_actual
		emit_signal("monedas_cambiadas", monedas_visuales)
		
func _iniciar_conteo_animado():
	# Detener animación anterior si existe
	if tween_contador and tween_contador.is_running():
		tween_contador.kill()
	
	tween_contador = create_tween()
	
	var diferencia = abs(monedas_actual - monedas_visuales)
	var duracion = clamp(diferencia * 0.02, 0.3, 2.0) 
	
	if monedas_actual > monedas_visuales:
		#empieza rápido y desacelera = ganar
		tween_contador.tween_method(
			_actualizar_valor_visual,
			monedas_visuales,
			monedas_actual,
			duracion
		).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	else:
		# empieza lento y acelera  = gastar
		tween_contador.tween_method(
			_actualizar_valor_visual,
			monedas_visuales,
			monedas_actual,
			duracion
		).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
	tween_contador.tween_callback(_finalizar_conteo)

func _actualizar_valor_visual(valor: float):
	monedas_visuales = int(valor)
	emit_signal("monedas_cambiadas", monedas_visuales)

func _finalizar_conteo():
	monedas_visuales = monedas_actual
	emit_signal("monedas_cambiadas", monedas_visuales)

func gastar_monedas(cantidad: int, con_animacion: bool = true) -> bool:
	if monedas_actual >= cantidad:
		monedas_actual -= cantidad
		if con_animacion:
			_iniciar_conteo_animado()
		else:
			monedas_visuales = monedas_actual
			emit_signal("monedas_cambiadas", monedas_visuales)
		return true
	return false
	
	
func obtener_inventario_dinero_despues_oleada(gano:bool):
	
	if gano:
		añadir_monedas(200) # al pasar la oleada y ganar entonces gana dinero
	else: # si perdio se le debe dejar el dinero que tenia antes de empezar la oleada y el inventario que tenia antes de empezar a colocar
		monedas_actual = monedas_antes_oleada 
	unificar_piezas(gano)

func unificar_piezas(gano:bool):
	#se corrigen los nombres a como lo tengo en dicc
	var piezas_convertidas = corregir_nombres(piezas_vivas) if not piezas_vivas.is_empty() else {}
	
	# se crear nuevo inventario completo (las piezas colocadas / o vivas y las que se tenian en el inventario
	var nuevo_inventario = {}
	for nombre in NOMBRES_PIEZAS:
		nuevo_inventario[nombre] = 0
	# sumar inventario actual
	for nombre in inventario_actual:
		nuevo_inventario[nombre] += inventario_actual[nombre]
	
	# si gano es igual a TRUE entonces se suman las piezas vivas, sino solo las que se colocó y se vuelve a jugar
	if gano:
		for nombre in piezas_convertidas:
			nuevo_inventario[nombre] += piezas_convertidas[nombre]
	else:
		for nombre in piezas_colocadas:
			nuevo_inventario[nombre] += piezas_colocadas[nombre]
	
	# actualizar inventario
	inventario_actual = nuevo_inventario
	
	# reiniciar las variables de piezas colocadas
	#inicializar_diccionarios()
	for nombre in NOMBRES_PIEZAS:
		piezas_colocadas[nombre] = 0
	economia.emit_signal("inventario_actualizado")

func corregir_nombres(piezasVivas:Array) -> Dictionary: # piezas_vivas = [1,2,1]
	const VALOR_A_NOMBRE = {
		1: "Peon",
		2: "Alfil",
		3: "Torre",
		4: "Caballo",
		5: "Reina"
	}
	
	var conteo = {}
	for nombre in NOMBRES_PIEZAS:
		conteo[nombre] = 0
	
	for valor in piezasVivas:
		if valor in VALOR_A_NOMBRE:
			var nombre = VALOR_A_NOMBRE[valor]
			conteo[nombre] += 1
	
	return conteo

func comprar_pieza(nombre_pieza:String) -> bool:
	if not nombre_pieza in datos_piezas:
		return false
	
	var datos = datos_piezas[nombre_pieza]
	
	# verificar monedas, si no alcanza vuelve (igualemnte es imposible comprar)
	if monedas_actual < datos["precio"]:
		if(GlobalJuego.tutorial):
			GlobalSignal.emit_signal("cambioTexto",3)
		return false
	
	# verificar límite, si llega al maximo
	if llego_al_limite(nombre_pieza):
		return false
	
	# si todo fue bien. se hace la compra
	if not GlobalJuego.debug:
		gastar_monedas(datos["precio"])
		#monedas_actual -= datos["precio"]
	
	inventario_actual[nombre_pieza] += 1
	
	
	pieza_comprada.emit({"nombre": nombre_pieza, "cantidad": inventario_actual[nombre_pieza]})
	inventario_actualizado.emit(inventario_actual)
	GlobalSignal.mensaje_tienda.emit(true,nombre_pieza)
	
	if (GlobalJuego.tutorial):
		GlobalSignal.emit_signal("seComproPieza")
	
	return true


func vender_pieza(nombre_pieza:String) -> bool:
	if not nombre_pieza in inventario_actual:
		return false
	
	if inventario_actual[nombre_pieza] <= 0:
		return false
	
	var valor_venta = datos_piezas[nombre_pieza]["valor_reventa"]
	
	# si todo sale bien se vente la pieza y se suma el valor de la reventa
	inventario_actual[nombre_pieza] -= 1
	
	if not GlobalJuego.debug:
		añadir_monedas(valor_venta)
		#monedas_actual += valor_venta
	
	pieza_comprada.emit({"nombre": nombre_pieza, "cantidad": inventario_actual[nombre_pieza]})
	pieza_vendida.emit()
	GlobalSignal.mensaje_tienda.emit(false,nombre_pieza)
	return true

func usar_pieza(nombre_pieza:String):
	if not nombre_pieza in inventario_actual:
		return false
	
	if inventario_actual[nombre_pieza] <= 0:
		return false
	
	# pasar esa pieza desde el inventario a colocadas
	inventario_actual[nombre_pieza] -= 1
	piezas_colocadas[nombre_pieza] += 1
	
	inventario_actualizado.emit(inventario_actual)
	return true
	
	
			

#func llego_al_limite(pieza_nombre:String ,cantidad_piezas:int)-> bool:
	#var total :int =0
	#for i in inventario_actual:
		#if i["nombre"] == pieza_nombre:
			#total += i["cantidad"]
	#for i in piezas_colocadas:
		#if i["nombre"] == pieza_nombre:
			#total += i["cantidad"]
	#if pieza_nombre in limite_piezas:
		#return total >= limite_piezas[pieza_nombre]
	#else:
		#return false
	
	
	#if cantidad_piezas == 0:
		#for i in inventario_actual:
			#if i["nombre"] == pieza_nombre:
				#cantidad_piezas = i["cantidad"]

func llego_al_limite(nombre_pieza: String) -> bool:
	if not nombre_pieza in datos_piezas:
		return false
	
	var total = inventario_actual.get(nombre_pieza, 0) + piezas_colocadas.get(nombre_pieza, 0)
	# si al sumar todas las piezas, las colocadas y las del inventario y llegan al limite impuesto, entocnes no es posible comprar mas
	return total >= datos_piezas[nombre_pieza]["limite"]

func verificar_orden_aparicion(nombre_pieza: String) -> bool:
	if not nombre_pieza in datos_piezas:
		return false
	# verificar la oleada actual, dependendiendo del numero se van mostrando las piezas
	return GlobalJuego.oleada_actual < datos_piezas[nombre_pieza]["orden_aparicion"]

func obtener_nombre_pieza(tipo:int):
	return NOMBRES_PIEZAS[tipo-1]

func _agregar_pieza_cambiada(tipo:int):
	var nombre = obtener_nombre_pieza(tipo)
	for i in inventario_actual:
		if i == nombre:
			inventario_actual[i]+=1
		economia.emit_signal("inventario_actualizado")
			
	
	
	
# funcion para obtener los datos de las piezas
func obtener_datos_pieza(nombre: String) -> Dictionary:
	return datos_piezas.get(nombre, {})
	
