extends RigidBody3D
class_name PiezaBase
# Propiedades de la pieza

#clase de pieza
@export var pieza_tipo: int
@export var pieza_blanca: bool

# CArga de parametros 
var vida = Piezas.vida[pieza_tipo]
var danio = Piezas.danio[pieza_tipo]
var cadencia = Piezas.cadencia[pieza_tipo]
var bonus_cantidad = Piezas.bonus_cantidad[pieza_tipo]
var bonus_a = Piezas.bonus_a[pieza_tipo]
@export var vision_range: float = 5.0
@export var angulo_frente: int

# Componentes
var movimiento_especifico = preload("res://scenes/pieza/movimiento/movimiento.tscn") # define le movimiento caracteristico de la pieza

# Nodos

@onready var health_bar = $HealthBar
@onready var dust_particles = $DustParticles
@onready var attack_timer = $AttackTimer
@onready var giro_inicial = $GiroInicial

# Contenedor par acargar escena del modelo
@onready var contenedor_modelo : Node3D = $ContenedorModelo # contenedor modelo imagen y funciones

# Referencia a la instancia de la pieza (con AnimationPlayer)
var instancia_objeto_pieza: Node3D
var animation_player : AnimationPlayer


# Variables de estado
var is_alive: bool = true
var can_attack: bool = true
var target_piece: RigidBody3D = null
var initial_health: int
var color="N"
var pieza_colocada=false
var animacion=false

func _ready():
	if pieza_blanca: color="B" 	
	# Configurar física
	linear_velocity = Vector3(0, linear_velocity.y, 0)  # que no se mueva a los costados
	#rebote
	physics_material_override.bounce =.3
	gravity_scale = 2.0
	
	cargar_objeto() # Asigna el modelo y objero con sus animaciones			
	#cargar_modelo_glb() #asigan el modelo 3d
	
	posicionamiento_giro() # gira la pieza a su posicion en grados
	cargar_movimiento() # Script de movimiento y estados

func _physics_process(delta: float) -> void:
	if animacion:
		animation_player.play("ataque_rey")
	
func cargar_objeto():
	var objeto = "res://assets/modelos/piezas/pieza_"+ str(pieza_tipo) + color +".tscn"
	var modelo_objeto = load(objeto)
	if not modelo_objeto:
		print ("No se puede cargar la escena del objeto pieza")
		return
		
	# Instanciar y agregar al contenedor
	instancia_objeto_pieza = modelo_objeto.instantiate()
	contenedor_modelo.add_child(instancia_objeto_pieza)
	
	# Buscar el AnimationPlayer dentro de esta instancia
	animation_player = _find_animation_player(instancia_objeto_pieza)

func _find_animation_player(node: Node) -> AnimationPlayer:
	for child in node.get_children():
		if child is AnimationPlayer:
			return child
		var found = _find_animation_player(child)
		if found:
			return found
	return null

# Método público para acceder a la animación desde los scripts de movimiento
func get_animation_player() -> AnimationPlayer:
	return animation_player
			
	
func cargar_movimiento(): # agrega el nodo movimiento con el script correspondiente a la pieza
	var movimiento = movimiento_especifico.instantiate()
	var movimiento_script = "res://scenes/pieza/movimiento/mov"+str(pieza_tipo)+ color+".gd"
	var script = load(movimiento_script)
	movimiento.set_script(script)
	add_child(movimiento)
	movimiento.owner = self  # ← IMPORTANTE: Establece el owner manualmente
	
			

func posicionamiento_giro():
	#temporizador
	giro_inicial.wait_time = 3.0   # 1 segundo
	giro_inicial.connect("timeout",llego_al_piso)
	giro_inicial.start()

func llego_al_piso():
	giro(angulo_frente)
	

func _on_body_entered(body):
	
	if pieza_colocada : return # solo se ejecuta en el inicio
	# este if es para que solo tenga un efecto de sonido cuando rebota 
	# Efecto de polvo
	create_dust_effect()
	
		# Sonido de golpe
	Sonidos.impacto()
	
func create_dust_effect(): # Particulas al pegar con el tablero
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
		target_piece.take_damage(danio)
		
		# Efecto visual de ataque
		create_attack_effect()
		
		attack_timer.start(1.0)  # Cooldown de 1 segundo
		await attack_timer.timeout
		can_attack = true

func take_damage(amount: int):
	vida -= amount
	update_health_bar()
	
	# Efecto visual de daño
	flash_red()
	
	# Sonido de daño
	Sonidos.hurt()
	
	if vida <= 0:
		die()

func update_health_bar():
	var health_percentage = float(vida) / float(initial_health)
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

func giro(angulo):
	
	"""
    Gira la pieza en el eje horizontal (Y) usando Tween
    
    Parámetros:
    - angulo_grados: Ángulo a rotar en grados (positivo = derecha, negativo = izquierda)
    - duracion: Duración de la animación en segundos
	"""
	var tween = create_tween()
	var rotacion_actual = rotation_degrees.y
	var rotacion_destino = angulo
	#print ("actual ",rotacion_actual,"ang ",angulo)
	#calcular el giro mas corto
	
	tween.tween_property(self, "rotation_degrees:y", rotacion_destino, 0.5)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	
	pieza_colocada = true
	physics_material_override.bounce = 0
	gravity_scale=1
