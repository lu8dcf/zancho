extends RigidBody3D

# Propiedades de la pieza
@export var piece_type: int = 2
@export var team: String = "B"
@export var health: int = 100
@export var attack_damage: int = 25
@export var vision_range: float = 5.0
@export var angulo_frente: int

# Nodos

@onready var health_bar = $HealthBar
@onready var dust_particles = $DustParticles
@onready var contenedor_modelo : Node3D = $ContenedorModelo # contenedor modelo glb

@onready var attack_timer = $AttackTimer
@onready var giro_inicial = $GiroInicial
@export var peon_blanco : PackedScene  # Modelo GLB para baldosa clara
@export var rey_blanco : PackedScene  # Modelo GLB para baldosa oscura

# Variables de estado
var is_alive: bool = true
var can_attack: bool = true
var target_piece: RigidBody3D = null
var initial_health: int


func _ready():
	# Configurar física
	gravity_scale = 2.0
	linear_velocity = Vector3(0, linear_velocity.y, 0)  # que no se mueva a los costados
	#rebote
	physics_material_override.bounce =.3
				
	# Inicializar UI
	initial_health = health
	update_health_bar()
		
	# Iniciar visión
	start_vision_check()
	
	initialize(piece_type,team)
	cargar_modelo_glb()
	posicionamiento()
	

func posicionamiento():
	#temporizador
	giro_inicial.wait_time = 3.0   # 1 segundo
	giro_inicial.connect("timeout",giro)
	giro_inicial.start()

	

func initialize(p_type: int, p_team: String):
	piece_type = p_type
	team = p_team
	
	
func cargar_modelo_glb():
	if not contenedor_modelo:
		push_error("Falta el nodo ContenedorModelo")
		return
	
	# Limpiar modelos anteriores
	for hijo in contenedor_modelo.get_children():
		hijo.queue_free()
	
	# Seleccionar el modelo según el tipo
	var modelo_a_cargar = peon_blanco
	
	if modelo_a_cargar:
		var instancia_modelo = modelo_a_cargar.instantiate()
		contenedor_modelo.add_child(instancia_modelo)
	else:
		push_error("No se ha asignado modelo GLB para baldosa tipo: ")

	
	initial_health = health
	update_health_bar()



func _on_body_entered(body):
	
	# este if es para que solo tenga un efecto de sonido cuando rebota 
	# Efecto de polvo
	create_dust_effect()
		# Sonido de golpe
	Sonidos.impacto()
	
	# Particulas al pegar con el tablero
func create_dust_effect():
	dust_particles.emitting = true
	await get_tree().create_timer(0.5).timeout
	dust_particles.emitting = false

func start_vision_check():
	while is_alive:
		await get_tree().create_timer(0.5).timeout
		check_for_enemies()

func check_for_enemies():
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = SphereShape3D.new()
	query.shape.radius = vision_range
	query.transform.origin = global_position
	query.collision_mask = 2  # Máscara de piezas enemigas
	
	var results = space_state.intersect_shape(query)
	
	var nearest_enemy = null
	var nearest_distance = vision_range + 1
	
	for result in results:
		var body = result.collider
		#if body is ChessPiece and body.team != team and body.is_alive:
		#	var distance = global_position.distance_to(body.global_position)
		#	if distance < nearest_distance:
		#		nearest_distance = distance
		#		nearest_enemy = body
	
	target_piece = nearest_enemy
	
	if target_piece and can_attack:
		attack_enemy()

func attack_enemy():
	if target_piece and target_piece.is_alive:
		can_attack = false
		target_piece.take_damage(attack_damage)
		
		# Efecto visual de ataque
		create_attack_effect()
		
		attack_timer.start(1.0)  # Cooldown de 1 segundo
		await attack_timer.timeout
		can_attack = true

func take_damage(amount: int):
	health -= amount
	update_health_bar()
	
	# Efecto visual de daño
	flash_red()
	
	# Sonido de daño
	Sonidos.hurt()
	
	if health <= 0:
		die()

func update_health_bar():
	var health_percentage = float(health) / float(initial_health)
	health_bar.value = health_percentage * 100
	
	# Cambiar color según salud
	if health_percentage > 0.6:
		health_bar.modulate = Color(0, 1, 0, 1)  # Verde
	elif health_percentage > 0.3:
		health_bar.modulate = Color(1, 1, 0, 1)  # Amarillo
	else:
		health_bar.modulate = Color(1, 0, 0, 1)  # Rojo

func flash_red():
	#var original_color = mesh_instance.material_override.albedo_color
	#mesh_instance.material_override.albedo_color = Color.RED
	await get_tree().create_timer(0.1).timeout
	#mesh_instance.material_override.albedo_color = original_color

func create_attack_effect():
	# Crear línea de ataque visual
	var line = ImmediateMesh.new()
	var line_mesh = MeshInstance3D.new()
	line_mesh.mesh = line
	
	# Animación de daño en el enemigo
	if target_piece:
		target_piece.flash_red()



func die():
	is_alive = false
	create_dust_effect()
	Sonidos.death()
	
	# Animación de muerte
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3.ZERO, 0.5)
	tween.tween_callback(queue_free)

func giro():
	
	"""
    Gira la pieza en el eje horizontal (Y) usando Tween
    
    Parámetros:
    - angulo_grados: Ángulo a rotar en grados (positivo = derecha, negativo = izquierda)
    - duracion: Duración de la animación en segundos
	"""
	var tween = create_tween()
	var rotacion_actual = rotation_degrees.y
	var rotacion_destino = rotacion_actual + angulo_frente
	
	tween.tween_property(self, "rotation_degrees:y", rotacion_destino, 1)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
