extends Node


# mapas hechos a mano (6 n total)
var mapas_base: Dictionary = {}

var tipo_obstaculo : Dictionary = {
	1: "res://assets/modelos/objetos/obstaculo_1.tscn",
	2: "res://assets/modelos/objetos/obstaculo_2.tscn",
	3: "res://assets/modelos/objetos/obstaculo_3.tscn",
	4: "res://assets/modelos/objetos/obstaculo_4.tscn",
	5: "res://assets/modelos/objetos/obstaculo_5.tscn",
	6: "res://assets/modelos/objetos/obstaculo_6.tscn",
}

# no se usara RNG en la generacion de los mapas, pero se usaran variaciones y automatizacion progresural
var datos_mapa : Dictionary={}
var variantes_por_mapa: Dictionary = {}

var seed_partida: int = 0

func _ready():
	randomize()
	seed_partida = randi()
	# posiciones donde habrá obstáculos
	cargar_mapas_base()
	cargar_variantes()
	# Mapa 0
		#0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
   #┌───────────────────────────────────────────────┐
 #0 │ .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . │
 #1 │ .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . │
 #2 │ .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . │
 #3 │ .  .  X  .  .  .  .  .  .  .  .  .  .  .  .  . │  ← Vector2i(2, 3)
 #4 │ .  .  .  .  .  .  .  .  .  .  X  .  .  .  .  . │  ← Vector2i(10, 4)
 #5 │ .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . │
 #6 │ .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . │
 #7 │ .  .  .  .  .  X  .  .  .  .  .  .  .  .  .  . │  ← Vector2i(5, 7)
 #8 │ .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . │
 #9 │ .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . │
#10 │ .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . │
#11 │ .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . │
#12 │ .  .  .  .  .  .  .  .  X  .  .  .  .  .  .  . │  ← Vector2i(8, 12)
#13 │ .  .  .  .  .  .  .  .  X  .  .  .  .  .  .  . │  ← Vector2i(8, 13)
#14 │ .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . │
#15 │ .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . │
   #└───────────────────────────────────────────────┘

func reiniciar_variables():
	mapas_base = {}
	variantes_por_mapa = {}
	cargar_mapas_base()
	cargar_variantes()

func cargar_mapas_base() -> void:
	mapas_base.clear()
	
	mapas_base[1] = {
		"posiciones": [
			Vector2i(2, 3),
			Vector2i(5, 7),
			Vector2i(10, 4)
		],
		"tipos": [
			1,
			2,
			1
		]
	}

	mapas_base[2] = {
		"posiciones": [
			Vector2i(2, 3),
			Vector2i(5, 7),
			Vector2i(10, 4),
			Vector2i(10, 5)
		],
		"tipos": [
			1,
			2,
			1,
			3
		]
	}

	mapas_base[3] = {
		"posiciones": [
			Vector2i(3, 3),
			Vector2i(4, 4),
			Vector2i(5, 5)
		],
		"tipos": [
			2,
			4,
			5
		]
	}

	mapas_base[4] = {
		"posiciones": [
			Vector2i(2, 2),
			Vector2i(6, 6),
			Vector2i(10, 10)
		],
		"tipos": [
			2,
			3,
			5
		]
	}

	mapas_base[5] = {
		"posiciones": [
			Vector2i(7, 7),
			Vector2i(8, 8)
		],
		"tipos": [
			3,
			5
		]
	}

	mapas_base[6] = {
		"posiciones": [
			Vector2i(7, 5),
			Vector2i(8, 3)
		],
		"tipos": [
			3,
			1
		]
	}

func cargar_variantes() -> void:
	variantes_por_mapa.clear()
	
	variantes_por_mapa[1] = [
		{
			"posicion": Vector2i(8, 12),
			"tipos_posibles": [2, 3],
			"desde_oleada_relativa": 3
		},
		{
			"posicion": Vector2i(8, 13),
			"tipos_posibles": [1, 2],
			"desde_oleada_relativa": 5
		},
		{
			"posicion": Vector2i(12, 6),
			"tipos_posibles": [4, 5],
			"desde_oleada_relativa": 5
		}
	]

	variantes_por_mapa[2] = [
		{
			"posicion": Vector2i(3, 8),
			"tipos_posibles": [1, 4],
			"desde_oleada_relativa": 2
		},
		{
			"posicion": Vector2i(11, 6),
			"tipos_posibles": [2, 6],
			"desde_oleada_relativa": 4
		}
	]

	variantes_por_mapa[3] = [
		{
			"posicion": Vector2i(6, 8),
			"tipos_posibles": [3, 5],
			"desde_oleada_relativa": 2
		},
		{
			"posicion": Vector2i(9, 9),
			"tipos_posibles": [1, 2],
			"desde_oleada_relativa": 4
		}
	]

	variantes_por_mapa[4] = [
		{
			"posicion": Vector2i(4, 11),
			"tipos_posibles": [2, 4],
			"desde_oleada_relativa": 2
		},
		{
			"posicion": Vector2i(12, 12),
			"tipos_posibles": [5, 6],
			"desde_oleada_relativa": 4
		}
	]

	variantes_por_mapa[5] = [
		{
			"posicion": Vector2i(6, 5),
			"tipos_posibles": [1, 3],
			"desde_oleada_relativa": 2
		},
		{
			"posicion": Vector2i(10, 6),
			"tipos_posibles": [4, 6],
			"desde_oleada_relativa": 4
		}
	]

	variantes_por_mapa[6] = [
		{
			"posicion": Vector2i(5, 10),
			"tipos_posibles": [2, 5],
			"desde_oleada_relativa": 2
		},
		{
			"posicion": Vector2i(11, 3),
			"tipos_posibles": [1, 6],
			"desde_oleada_relativa": 4
		}
	]

#elegir que mapa toca en las primeras 20 oleadas
func obtener_mapa_id_por_oleada(oleada:int)-> int:
	if oleada>=1 and oleada <=5:
		return 1
	if oleada>=6 and oleada <=10:
		return 2
	if oleada>=11 and oleada <=13:
		return 3
	if oleada>=14 and oleada <=16:
		return 4
	if oleada>=17 and oleada <=18:
		return 5
	if oleada>=19 and oleada <=20:
		return 6
	return obtener_mapa_id_automatico(oleada) # si la oleada no esta entre las primeras 20 entonces se hace automatico el mapa 

func obtener_mapa_id_automatico(oleada:int) -> int:
	var oleada_post_20 := oleada - 21
	var bloque := int(floor(float(oleada_post_20) / 5.0))

	# aca va rotando entre los 6 mapas base.
	return bloque % 6 + 1

func siguiente_mapa():
	for mapa in datos_mapa:
		var oleadas = datos_mapa[mapa]
		if GlobalJuego.oleada_actual in oleadas:
			GlobalJuego.mapa_actual = mapa
			print("mapa acual e: ", GlobalJuego.mapa_actual, " oleada en: ", GlobalJuego.oleada_actual)

# mapas automatizados
func obtener_oleada_relativa(oleada:int) -> int:
	
	if oleada >= 1 and oleada <= 5:
		return oleada

	if oleada >= 6 and oleada <= 10:
		return oleada - 5

	if oleada >= 11 and oleada <= 13:
		return oleada - 10

	if oleada >= 14 and oleada <= 16:
		return oleada - 13

	if oleada >= 17 and oleada <= 18:
		return oleada - 16

	if oleada >= 19 and oleada <= 20:
		return oleada - 18

	var oleada_post_20 := oleada - 21
	return oleada_post_20 % 5 + 1

func obtener_cantidad_variantes(oleada: int) -> int:
	var oleada_relativa := obtener_oleada_relativa(oleada)

	if oleada <= 20:
		match oleada_relativa:
			1, 2:
				return 0
			3, 4:
				return 1
			5:
				return 2
			_:
				return 1

	# Después de oleada 20, empieza a crecer un poco.
	var bloque_post_20 := int(floor(float(oleada - 21) / 5.0))
	var cantidad := 2 + int(floor(float(bloque_post_20) / 2.0))

	return clamp(cantidad, 2, 5)

# Ejemplo de como serian las oleadas
#Oleada 1-2: 0 variantes
#Oleada 3-4: 1 variante
#Oleada 5: 2 variantes
#
#Después de oleada 20:
#Al principio 2 variantes.
#Luego 3.
#Luego 4.
#Máximo 5.

func generar_variantes_controladas(mapa_id: int, oleada: int) -> Array:
	var resultado: Array = []

	if not variantes_por_mapa.has(mapa_id):
		return resultado

	var cantidad := obtener_cantidad_variantes(oleada)
	if cantidad <= 0:
		return resultado

	var oleada_relativa := obtener_oleada_relativa(oleada)
	var slots_disponibles: Array = []

	for slot in variantes_por_mapa:
		if oleada_relativa >= slot["desde_oleada_relativa"]:
			slots_disponibles.append(slot)

	if slots_disponibles.is_empty():
		return resultado

	var rng := RandomNumberGenerator.new()

	# Esta seed hace que las variantes sean estables.
	# No cambian caóticamente cada vez que llamás la función.
	var bloque := obtener_bloque_de_mapa(oleada)
	rng.seed = seed_partida + mapa_id * 1000 + bloque * 10000

	slots_disponibles = mezclar_array_determinista(slots_disponibles, rng)

	var cantidad_final = min(cantidad, slots_disponibles.size())

	for i in range(cantidad_final):
		var slot = slots_disponibles[i]
		var tipos_posibles: Array = slot["tipos_posibles"]
		var tipo_index := rng.randi_range(0, tipos_posibles.size() - 1)

		resultado.append({
			"posicion": slot["posicion"],
			"tipo": tipos_posibles[tipo_index]
		})

	return resultado

func obtener_bloque_de_mapa(oleada: int) -> int:
	if oleada >= 1 and oleada <= 5:
		return 1

	if oleada >= 6 and oleada <= 10:
		return 2

	if oleada >= 11 and oleada <= 13:
		return 3

	if oleada >= 14 and oleada <= 16:
		return 4

	if oleada >= 17 and oleada <= 18:
		return 5

	if oleada >= 19 and oleada <= 20:
		return 6

	return 7 + int(floor(float(oleada - 21) / 5.0))

func mezclar_array_determinista(array_original: Array, rng: RandomNumberGenerator) -> Array:
	var array := array_original.duplicate()

	for i in range(array.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var temp = array[i]
		array[i] = array[j]
		array[j] = temp

	return array

func obtener_mapa_para_oleada(oleada: int) -> Dictionary:
	var mapa_id := obtener_mapa_id_por_oleada(oleada)

	if not mapas_base.has(mapa_id):
		push_warning("No existe el mapa base: " + str(mapa_id))
		return {
			"posiciones": [],
			"tipos": []
		}

	var mapa_base: Dictionary = mapas_base[mapa_id]

	var posiciones: Array = mapa_base["posiciones"].duplicate()
	var tipos: Array = mapa_base["tipos"].duplicate()

	var variantes := generar_variantes_controladas(mapa_id, oleada)

	for variante in variantes:
		posiciones.append(variante["posicion"])
		tipos.append(variante["tipo"])

	return {
		"id_mapa": mapa_id,
		"posiciones": posiciones,
		"tipos": tipos
	}
