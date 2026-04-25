extends Node


# Crear las piezas sobre el tablero
signal crearPieza (sitio:Vector2,tipo:int,blanca:bool)

# Pasos del juego
signal marcaPaso
signal controlMarcaPaso (activa : bool)

#Cuando el player este listo
signal comienzaAtaque
