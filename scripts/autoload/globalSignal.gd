extends Node


# Crear las piezas sobre el tablero
@warning_ignore("unused_signal")
signal crearPieza (sitio:Vector2,tipo:int,blanca:bool)

# Pasos del juego
@warning_ignore("unused_signal")
signal marcaPaso
@warning_ignore("unused_signal")
signal controlMarcaPaso (activa : bool)
@warning_ignore("unused_signal")
signal aceleraMarcaPaso (multi : int)


@warning_ignore("unused_signal")
signal comienzoOleada #Senial que debe emitir cuando comienza la oleada
@warning_ignore("unused_signal")
signal finalizaOleada(estado: bool) #true gano rey   false muere rey
@warning_ignore("unused_signal")
signal nuevaOleada(estado: bool) #true gano rey   false muere rey con diferencia de tiempo 


# Secuencia de ataques
@warning_ignore("unused_signal")
signal ataque (idA:int,idD:int,posicionA:Vector3i,posicionD:Vector3i,tipoA:int,tipoD:int)#Senial que debe emitir cuando comienza la oleada
@warning_ignore("unused_signal")
signal giro_pieza(id: int,angulo:float)
@warning_ignore("unused_signal")
signal piezaAtaca(id: int)
@warning_ignore("unused_signal")
signal piezaRecibeDanio(id: int,danio: int)
@warning_ignore("unused_signal")
signal piezaMuere(id: int)

@warning_ignore("unused_signal")
signal finAtaque(gano: int,color: bool,perdio: int)  # tipo: int, blanca:bool si es true es blanca y si es false es negra

# Acciones del jugador
@warning_ignore("unused_signal")
signal overPieza(activo:bool, tipo: int, blanca: bool, posicion: Vector3i) # si es activo: true tiene el mouse encima y si es false entocnes sale
@warning_ignore("unused_signal")
signal clickReina()
@warning_ignore("unused_signal")
signal cambioLugar(tipo:int)
@warning_ignore("unused_signal")
signal punteroReina(positionSeleccionada : Vector3i, iluminarCasilla : bool)  #retorna la posicion 


# mensajes para el log
@warning_ignore("unused_signal")
signal mensaje_oleada(empieza:bool,gano:bool) 
@warning_ignore("unused_signal")
signal mensaje_tienda(compra:bool,pieza:String) # si es true la compra quiere decir que compró una pieza

#Seniales para el tutorial
@warning_ignore("unused_signal")
signal tiendaHoverParpadea
@warning_ignore("unused_signal")
signal tutorialVisible
@warning_ignore("unused_signal")
signal cambioTexto(nroTexto: int)
@warning_ignore("unused_signal")
signal tiendaClick
@warning_ignore("unused_signal")
signal parpadeoPiezas
@warning_ignore("unused_signal")
signal seComproPieza
@warning_ignore("unused_signal")
signal parpadearTabla
@warning_ignore("unused_signal")
signal parpadeaOleadar
@warning_ignore("unused_signal")
signal PantallaNegra
@warning_ignore("unused_signal")
signal ultimoTexto
#signal obtenerBaldosa(posicion : Vector2i)
#signal retornoBaldosa(baldosa : BaldosaBase)

# efectos
@warning_ignore("unused_signal")
signal conteoMonedas
