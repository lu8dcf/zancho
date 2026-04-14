#extends Node
#class_name UbicaObjeto
								## vector(3,2) posicion de la baldosa
#func ubicar_objetos(coordenadas: Vector2i, objeto) -> Vector3:
	#var objeto = obtener_baldosa_en_coordenadas(coordenadas)
	#if objeto:
		#return objeto.obtener_punto_colocacion()
	#return Vector3.ZERO
	#
