extends Node3D
class_name Material_Peon

@onready var circulo_mesh: MeshInstance3D = $"Esqueleto/Skeleton3D/Círculo_001"
@export var material: String  
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
	material=Piezas.material_muerte
	var material_muerte = load(material)
	circulo_mesh.material_override = material_muerte
	matar_con_animacion(material_muerte)

func matar_con_animacion(mat: ShaderMaterial):
	var parametro_nombre = "progreso_disolver"  # Nombre de tu variable en el shader
	
	# Establecer valor inicial
	mat.set_shader_parameter(parametro_nombre, 0.3)
	
	# Crear tween que interpola automáticamente
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/" + parametro_nombre, 1.0, 3.0)		
