extends Node2D


# 1. Cargamos la escena de la moneda (asegurate de poner la ruta correcta a tu archivo)
const ESCENA_MONEDA = preload("res://scenes/ui/monedas/moneda.tscn")


func _ready() -> void:
	generar_lluvia_de_monedas()
# Función que podés llamar desde cualquier parte del juego para activar el efecto
func generar_lluvia_de_monedas() -> void:
	var cantidad_monedas: int = 20
	
	for i in range(cantidad_monedas):
		# A. Instanciar la moneda en memoria
		var nueva_moneda = ESCENA_MONEDA.instantiate()
		add_child(nueva_moneda)
		
		# C. Calcular un tiempo de espera aleatorio entre 0.2 y 0.5 segundos para la próxima moneda
		var tiempo_espera: float = randf_range(0.05, 0.1)
		
		# D. Pausar el bucle temporalmente sin congelar el resto del juego
		await get_tree().create_timer(tiempo_espera).timeout
