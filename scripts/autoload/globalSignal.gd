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

# Secuencia de ataques
@warning_ignore("unused_signal")
signal ataque (idA:int,idD:int,posicionA:Vector3i,posicionD:Vector3i)#Senial que debe emitir cuando comienza la oleada
@warning_ignore("unused_signal")
signal giro_pieza(id: int,angulo: Vector3)
