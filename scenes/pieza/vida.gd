extends Node3D


var danio = 10
@onready var barraVerde = $vidaverde
var esVisible: bool = false
signal VidaEsCero

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func bajarVida():
	if (!esVisible):
		esVisible = true
		visible = true
		return
	if(barraVerde.scale.y > 0):
		barraVerde.scale.y -= danio
	else:
		emit_signal("VidaEsCero")
