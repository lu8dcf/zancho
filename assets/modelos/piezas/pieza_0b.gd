extends Node3D


@onready var circulo_mesh: MeshInstance3D = $"Esqueleto_008/Skeleton3D/Círculo_037"


@onready var material_bueno: Material = preload("res://assets/modelos/texturas/material_buenos.tres")
@onready var material_muerte: Material = preload("res://assets/modelos/texturas/muerte.tres")


var usando_material_muerte: bool = false

func _ready() -> void:
	if circulo_mesh and material_bueno:
		
		var mat_unico = material_bueno.duplicate(true) as ShaderMaterial
		circulo_mesh.material_override = mat_unico
		
		

func _unhandled_input(event: InputEvent) -> void:

	if event is InputEventKey and event.pressed and event.keycode == KEY_G:
		cambiar_a_material_muerte()

func cambiar_a_material_muerte() -> void:
	usando_material_muerte = !usando_material_muerte
	
	var material_a_usar: Material
	if usando_material_muerte:
		material_a_usar = material_muerte
		
	else:
		material_a_usar = material_bueno
		

	if material_a_usar:
		
		var mat_nuevo_unico = material_a_usar.duplicate(true) as ShaderMaterial
		circulo_mesh.material_override = mat_nuevo_unico
		
	


		
		
