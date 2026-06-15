extends Node

enum TutorialState { #maquina de estados!
	TIENDA,
	COMPRA_PIEZA,
	SELECCION_PIEZA,
	COMIENZO_OLEADA,
	FIN_OLEADA,
	COMPLETO
}

var estado : TutorialState = TutorialState.TIENDA

##instruccionesCumplidas
#var tiendaClickeada : bool = false #se abre el menu
#var piezaComprada : bool = false #se compra pieza
#var piezaSeleccionada : bool = false #selecciono pieza para poner
#
##var obtuveBaldosa :bool = false
#
#var piezaPosicionada : bool = false #se posiciona pieza
#var comienzoOleada : bool = false
#var mostroTabla : bool = false
#var ganoOleada : bool = false
#var tutorialCompleto : bool = false

#var baldosa : BaldosaBase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("TUTORIAL READY")
	await esperar(5)
	GlobalSignal.emit_signal("tutorialVisible")
	estado = TutorialState.TIENDA
	presentacionTienda()
	
	#señalesConectadas
	GlobalSignal.connect("tiendaClick",tiendaClick)
	GlobalSignal.connect("seComproPieza", piezaEnInventario)
	Piezas.connect("modo_colocacion_true", ComienzoOleadaTut)
	#Piezas.connect("modo_colocacion_true", hacerParpadearBaldosa)
	#GlobalSignal.connect("retornoBaldosa", obtengoBaldosa)
	
	GlobalSignal.connect("comienzoOleada", comenzoOleada)
	GlobalSignal.connect("PantallaNegra", finDeOleada)
	pass # Replace with function body.

func esperar(segundos: float) -> void:
	await get_tree().create_timer(segundos).timeout


func presentacionTienda():
	while estado == TutorialState.TIENDA:
		GlobalSignal.emit_signal("tiendaHoverParpadea")
		await esperar(2)
	

func tiendaClick():
	if estado != TutorialState.TIENDA:
		return
	estado = TutorialState.COMPRA_PIEZA
	GlobalSignal.emit_signal("cambioTexto",2) #compraEn tienda
	
func piezaEnInventario():
	if estado != TutorialState.COMPRA_PIEZA:
		return
	estado = TutorialState.SELECCION_PIEZA
	GlobalSignal.emit_signal("cambioTexto",4) #instruccion, poner pieza
	seDebeSeleccionarPieza()

func seDebeSeleccionarPieza():
	while estado == TutorialState.SELECCION_PIEZA:
		GlobalSignal.emit_signal("parpadeoPiezas")
		await esperar(3)
	#hacerParpadearBaldosa()
#func hacerParpadearBaldosa(): #(3,12)
	#piezaSeleccionada = true
	#if(obtuveBaldosa):
		#baldosa.parpadearBaldosa()
	#
#func obtengoBaldosa(obj : BaldosaBase):
	#baldosa = obj
	#if(baldosa!=null):
		#print("baldosa:", baldosa)
		#obtuveBaldosa = true
		#hacerParpadearBaldosa()
	#
		#
#func colocarPieza():
	#piezaPosicionada = true
	#print("PosicionePieza")
	#

	
func ComienzoOleadaTut():
	if estado != TutorialState.SELECCION_PIEZA:
		return
	estado = TutorialState.COMIENZO_OLEADA
	GlobalSignal.emit_signal("cambioTexto",5) #apretar la oleada para comenzar el ataque
	while estado == TutorialState.COMIENZO_OLEADA:
		GlobalSignal.emit_signal("parpadeaOleadar")
		await esperar(2)
	
func comenzoOleada():
	if estado != TutorialState.COMIENZO_OLEADA:
		return
	estado = TutorialState.FIN_OLEADA
	GlobalSignal.emit_signal("cambioTexto",6) #tabla de defensa
	for i in range(3):
		GlobalSignal.emit_signal("parpadearTabla")
		await esperar(5)
	GlobalSignal.emit_signal("cambioTexto",10) #ataque de piezas
	await esperar(5)
	GlobalSignal.emit_signal("cambioTexto",11) #camara
	await esperar(7)
	GlobalSignal.emit_signal("cambioTexto",7) #suerte
	await esperar(4)
	GlobalSignal.emit_signal("tutorialVisible")
	
func finDeOleada():
	if estado != TutorialState.FIN_OLEADA:
		return
	estado = TutorialState.COMPLETO
	GlobalSignal.emit_signal("tutorialVisible")
	GlobalSignal.emit_signal("cambioTexto",8) #explicacion de fe
	await esperar(5)
	GlobalSignal.emit_signal("cambioTexto",9) #final
	await esperar(3)
	GlobalSignal.emit_signal("ultimoTexto")
	await esperar(3)
	GlobalJuego.reiniciar_variables()
	GlobalJuego.tutorial = false
	get_tree().change_scene_to_file("res://scenes/ui/main.tscn")
#func paseEntreTexto():
	#await get_tree().create_timer(3).timeout
	#GlobalSignal.emit_signal("cambioTexto",2)
	#await get_tree().create_timer(3).timeout
	#GlobalSignal.emit_signal("cambioTexto",3)
	#await get_tree().create_timer(3).timeout
	#GlobalSignal.emit_signal("cambioTexto",4)
	#await get_tree().create_timer(3).timeout

	
