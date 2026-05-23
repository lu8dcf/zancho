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
