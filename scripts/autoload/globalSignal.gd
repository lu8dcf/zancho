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
