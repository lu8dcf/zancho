extends Panel

@onready var hover: TextureButton = $hover
@onready var pieza: TextureButton = $pieza
@onready var venta: TextureButton = $venta
@onready var compra: TextureButton = $compra

func _ready() -> void:
	var nombre_del_panel = name  # Esto devolverá "Peon"
	print(nombre_del_panel)
	hover.visible =false
	print(economia.obtener_pieza_dicc(nombre_del_panel))


func _on_venta_pressed() -> void:
	pass # Replace with function body.


func _on_compra_pressed() -> void:
	pass # Replace with function body.



func _on_pieza_mouse_entered() -> void:
	hover.visible = true

func _on_pieza_mouse_exited() -> void:
	hover.visible =false
