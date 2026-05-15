extends Node3D


var danio = 10
@onready var barraVerde = $vidaverde
var esVisible: bool = false
var pieza: PiezaBase

func _ready():
	# Obtener la referencia a la pieza base (el owner del componente)
	pieza = get_parent() as PiezaBase

func bajarVida():
	if (!esVisible):
		esVisible = true
		visible = true
		return
	if(barraVerde.scale.y > 0):
		barraVerde.scale.y -= danio
	
