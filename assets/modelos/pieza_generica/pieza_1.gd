extends Node3D


@onready var circulo_mesh: MeshInstance3D = $"Esqueleto/Skeleton3D/Círculo_001"


@onready var material_bueno: Material = preload("res://assets/modelos/texturas/material_buenos.tres")
@onready var material_muerte: Material = preload("res://assets/modelos/texturas/material_muerte.tres")


var usando_material_muerte: bool = false

func _ready() -> void:
	if circulo_mesh and material_bueno:
		
		var mat_unico = material_bueno.duplicate(true) as ShaderMaterial
		circulo_mesh.material_override = mat_unico
	GlobalSignal.connect("piezaMuere",cambiar_a_material_muerte)	
		

func cambiar_a_material_muerte(id) -> void:
		
	var material_a_usar = material_muerte
	
	if material_a_usar:
		var mat_nuevo_unico = material_a_usar.duplicate(true) as ShaderMaterial
		circulo_mesh.material_override = mat_nuevo_unico
		
