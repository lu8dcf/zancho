extends Label
var notVisible : bool = false
var DATA_TUTORIALES = preload("res://scenes/tutorial/data_tutorial.gd").new() #aca estan todos los textos

@onready var label = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	label.text = DATA_TUTORIALES.instrucciones[1]
	GlobalSignal.connect("tutorialVisible",visibleOinvisible)
	GlobalSignal.connect("cambioTexto",cambioTexto)
	
	GlobalSignal.connect("ultimoTexto", transicionTextoFinal)
	pass # Replace with function body.


func visibleOinvisible():
	notVisible = !notVisible
	self.visible = notVisible


func cambioTexto(nro : int):
	if(DATA_TUTORIALES.instrucciones.has(nro)):
		label.text = DATA_TUTORIALES.instrucciones.get(nro)


func transicionTextoFinal():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.5, 1.5, 1.5, 0.0), 1.5)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
