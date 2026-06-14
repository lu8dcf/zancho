extends Node

#instruccionesCumplidas
var tiendaClickeada : bool = false #se abre el menu
var piezaComprada : bool = false #se compra pieza
var piezaSeleccionada : bool = false #selecciono pieza para poner

#var obtuveBaldosa :bool = false

var piezaPosicionada : bool = false #se posiciona pieza
var comienzoOleada : bool = false
var mostroTabla : bool = false
var ganoOleada : bool = false
var tutorialCompleto : bool = false

var baldosa : BaldosaBase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	await get_tree().create_timer(5).timeout
	#senialesEmitidas
	GlobalSignal.emit_signal("tutorialVisible")
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

func presentacionTienda():
	while(!tiendaClickeada):
		GlobalSignal.emit_signal("tiendaHoverParpadea")
		await get_tree().create_timer(2).timeout
	

func tiendaClick():
	tiendaClickeada = true
	GlobalSignal.emit_signal("cambioTexto",2)
	
func piezaEnInventario():
	piezaComprada =true
	GlobalSignal.emit_signal("cambioTexto",4)
	seDebeSeleccionarPieza()

func seDebeSeleccionarPieza():
	while(!piezaSeleccionada):
		GlobalSignal.emit_signal("parpadeoPiezas")
		await get_tree().create_timer(3).timeout
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
	piezaSeleccionada = true
	GlobalSignal.emit_signal("cambioTexto",5)
	while(!comienzoOleada):
		GlobalSignal.emit_signal("parpadeaOleadar")
		await get_tree().create_timer(2).timeout
	
func comenzoOleada():
	comienzoOleada = true
	GlobalSignal.emit_signal("cambioTexto",6)
	for i in 3:
		GlobalSignal.emit_signal("parpadearTabla")
		await get_tree().create_timer(5).timeout
	GlobalSignal.emit_signal("cambioTexto",10)
	await get_tree().create_timer(5).timeout	
	GlobalSignal.emit_signal("cambioTexto",11)
	await get_tree().create_timer(7).timeout
	GlobalSignal.emit_signal("cambioTexto",7)
	await get_tree().create_timer(3).timeout
	GlobalSignal.emit_signal("tutorialVisible")
	
func finDeOleada():
	GlobalSignal.emit_signal("tutorialVisible")
	GlobalSignal.emit_signal("cambioTexto",8)
	await get_tree().create_timer(5).timeout
	GlobalSignal.emit_signal("cambioTexto",9)
	await get_tree().create_timer(3).timeout
	GlobalSignal.emit_signal("ultimoTexto")
	await get_tree().create_timer(3).timeout
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

	
