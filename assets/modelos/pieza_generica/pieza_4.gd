extends Node3D


@onready var circulo_mesh: MeshInstance3D = $"Esqueleto_002/Skeleton3D/Círculo_007"


@onready var material: String
@onready var id: int

func _ready() -> void:
	var material_uso:Material =load(material)
	
	if circulo_mesh and material_uso:
		
		var mat_unico = material_uso.duplicate(true) as ShaderMaterial
		circulo_mesh.material_override = mat_unico
	GlobalSignal.connect("piezaMuere",cambiar_a_material_muerte)	
		

func cambiar_a_material_muerte(idA):
	if id!=idA:  # si no es el mismo evita cambiar
		return
	
	var material_muerte: Material = load(Piezas.material_muerte)
	
	if material_muerte:
		var mat_nuevo_unico = material_muerte as ShaderMaterial
		circulo_mesh.material_override = mat_nuevo_unico
		
