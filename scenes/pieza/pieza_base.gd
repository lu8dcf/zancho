extends RigidBody3D

# Propiedades de la pieza
@export var piece_type: String = "pawn"
@export var team: String = "red"
@export var health: int = 100
@export var attack_damage: int = 25
@export var vision_range: float = 5.0

# Nodos
@onready var mesh_instance = $MeshInstance3D
@onready var health_bar = $HealthBar
@onready var dust_particles = $DustParticles
@onready var impact_audio = $ImpactAudio
@onready var collision_timer = $CollisionTimer
@onready var attack_timer = $AttackTimer

# Variables de estado
var is_alive: bool = true
var can_attack: bool = true
var target_piece: RigidBody3D = null
var initial_health: int

func _ready():
	# Configurar física
	gravity_scale = 2.0
	#rebote
	physics_material_override.bounce =.5

	mass = 1.0
	
	# Configurar colisiones
	collision_layer = 2
	collision_mask = 1 | 2
	
	# Conectar señales
	body_entered.connect(_on_body_entered)
	
	# Inicializar UI
	initial_health = health
	update_health_bar()
	
	# Iniciar visión
	start_vision_check()
	
	initialize(piece_type,team)
	

func initialize(p_type: String, p_team: String):
	piece_type = p_type
	team = p_team
	setup_piece_properties()

func setup_piece_properties():
	match piece_type:
		"pawn":
			health = 50
			attack_damage = 20
			vision_range = 4.0
			set_mesh_color(Color(0.8, 0.6, 0.4))
			print ("pawn")
		"rook":
			health = 100
			attack_damage = 35
			vision_range = 8.0
			set_mesh_color(Color(0.6, 0.4, 0.8))
		"knight":
			health = 80
			attack_damage = 30
			vision_range = 5.0
			set_mesh_color(Color(0.4, 0.7, 0.8))
	
	initial_health = health
	update_health_bar()

func set_mesh_color(color: Color):
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	if team == "red":
		material.albedo_color = Color(color.r, color.g, color.b, 1.0)
	else:
		material.albedo_color = Color(color.r * 0.6, color.g * 0.6, color.b * 1.0, 1.0)
	mesh_instance.material_override = material

func _on_body_entered(body):
	# Efecto de polvo
	create_dust_effect()
	
	# Sonido de golpe
	play_impact_sound()
	
	# Aplicar impulso al cuerpo que golpeó
	if body is RigidBody3D and body != self:
		var impact_force = linear_velocity.length() * 2
		if impact_force > 5:
			body.apply_central_impulse(-linear_velocity.normalized() * impact_force)

func create_dust_effect():
	dust_particles.emitting = true
	await get_tree().create_timer(0.5).timeout
	dust_particles.emitting = false

func play_impact_sound():
	impact_audio.volume_db = -10 + randf_range(-5, 5)
	impact_audio.pitch_scale = 0.8 + randf_range(-0.2, 0.2)
	impact_audio.play()

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
	var original_color = mesh_instance.material_override.albedo_color
	mesh_instance.material_override.albedo_color = Color.RED
	await get_tree().create_timer(0.1).timeout
	mesh_instance.material_override.albedo_color = original_color

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
