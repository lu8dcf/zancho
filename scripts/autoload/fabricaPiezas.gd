extends Node




func colocar_pieza(sitio: Vector2i, tipo: int , blanca: bool):
	
	if lugar_disponible(sitio):
		return
		
	match tipo:
		1: # rey
			pass
		2: # peon
			pass
		3: # alfil
			pass
		4: # torre
			pass
		5: # caballlo
			pass
		6: # reina
			pass
	
# verificacion que el sitio este vacio para colocar la pieza
func lugar_disponible(sitio: Vector2i):
	# Verificacion de obstaculos en el mapa
	if sitio in mapas.mapa[globalJuego.mapa_actual]:
		globalJuego.mensaje("No se puede insertar sobre un obstaculo")
		return false	
	# verificar si esta ocupado por otra pieza	
	if sitio in mapas.mapa[globalJuego.mapa_actual]:
		globalJuego.mensaje("No se puede insertar sobre un obstaculo")
		return false	
