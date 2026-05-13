extends RigidBody3D
class_name PiezaBase

# Parametros de mundo
var espaciado = GlobalJuego.espaciado_baldosas

# Propiedades de la pieza

#clase de pieza
@export var pieza_tipo: int
@export var pieza_blanca: bool
@export var id:int # id de registro en base de datos
@export var pieza_sitio:Vector2i

# CArga de parametros pieza
var vida_total = Piezas.vida[pieza_tipo]
var vida_actual = vida_total


var angulo_frente: int = 225

# Componentes
var movimiento_especifico = preload("res://scenes/pieza/movimiento/movimiento.tscn") # define le movimiento caracteristico de la pieza
var ataque_especifico = preload("res://scenes/pieza/ataque/Ataque.tscn") # define le movimiento caracteristico de la pieza

# Nodos
@onready var dust_particles = $DustParticles
@onready var giro_inicial = $GiroInicial
#Area de ataque
@onready var area_ataque: Area3D = $AreaAtaque

# Contenedor par acargar escena del modelo
@onready var contenedor_movimiento : Node3D = $ContenedorMovimiento # contenedor modelo imagen y funciones
@onready var contenedor_ataque : Node3D = $ContenedorMovimiento # contenedor modelo imagen y funciones

# Referencia a la instancia de la pieza (con AnimationPlayer)
var instancia_objeto_pieza: Node3D
var animation_player : AnimationPlayer


# Variables de estado
var is_alive: bool = true
var color="N"
var pieza_colocada=false
var pieza : Resource
var secuencia_sfx = 0


func _ready():
	#print (pieza_sitio)
	if pieza_blanca: color="B" 	
	
	pieza = load("res://scripts/resource/pieza"+ str(pieza_tipo) + color +".tres")
	
	# Configurar física
	linear_velocity = Vector3(0, linear_velocity.y, 0)  # que no se mueva a los costados
	#rebote
	physics_material_override.bounce =.3
	gravity_scale = 2.0
	
	cargar_objeto() # Asigna el modelo y objero con sus animaciones			
	#cargar_modelo_glb() #asigan el modelo 3d
	
	posicionamiento_giro() # gira la pieza a su posicion en grados
	
	cargar_movimiento() # Script de movimiento y estados
	cargar_ataque() # Scrip de zona de ataque
	#GlobalSignal.connect("marcaPaso",anima_idle)
	animacion("Bidle")
	
	GlobalSignal.connect("giro_pieza",giro_remoto)
	GlobalSignal.connect("piezaAtaca",ataque)
	GlobalSignal.connect("piezaRecibeDanio",recibeDanio)

func _physics_process(_delta: float):
	pass
	#if animacion:
	#	animation_player.play("ataque_rey")
	
func cargar_objeto():# Instanciar y agregar al contenedor
	
	instancia_objeto_pieza = pieza.modelo.instantiate()
	contenedor_movimiento.add_child(instancia_objeto_pieza)
	
	# Buscar el AnimationPlayer dentro de esta instancia
	animation_player = _find_animation_player(instancia_objeto_pieza)

func _find_animation_player(node: Node) -> AnimationPlayer: # agrega las animaciones del mnodelo a la pieza
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

func cargar_ataque(): # agrega el nodo ataque con el script correspondiente a la pieza
	var ataque = ataque_especifico.instantiate()
	var ataque_script = "res://scenes/pieza/ataque/ataque1.gd"
	var script = load(ataque_script)
	ataque.set_script(script)
	add_child(ataque)
	ataque.owner = self  # ← IMPORTANTE: Establece el owner manualmente
		
		
# colocacion inicial --------------------------------------------------------------------------------		
func posicionamiento_giro(): # Giro inicial de la pieza an colocarse en el tablero hay que cambiar a radianes
	#temporizador
	giro_inicial.wait_time = 3.0   # 1 segundo
	giro_inicial.connect("timeout",llego_al_piso)
	giro_inicial.start()

func llego_al_piso():
	giro(angulo_frente)
	
func _on_body_entered(_body): #cuando la pieza se instancia y cae 
	if pieza_colocada : return # solo se ejecuta en el inicio
	# este if es para que solo tenga un efecto de sonido cuando rebota 
	#create_dust_effect()# Efecto de polvo
	Sonidos.impacto()# Sonido de golpe
	
func create_dust_effect(): # Particulas al pegar con el tablero
	dust_particles.emitting = true
	await get_tree().create_timer(0.5).timeout
	dust_particles.emitting = false
# fin de colocacion inicial --------------------------------------------------------------------------------	


func verificar_proximo_paso(cambio):
	# proximo sitio a ocupar
	var sitio3d = round(global_position+cambio)/globalJuego.espaciado_baldosas # en 3d
	# convierto la proxima posicion en 2Di para 
	var nuevo_sitio = Vector2i(sitio3d.x,sitio3d.z)  # en 2d
	if globalJuego.lugar_disponible(nuevo_sitio)==false:
		#print (pieza_sitio," ocupado")
		return false
	return true
		
func giro(angulo): #Gira la pieza en el eje horizontal (Y) usando Tween
	var tween = create_tween()
	var _rotacion_actual = rotation_degrees.y
	var rotacion_destino = angulo
	
	#calcular el giro mas corto
	Sonido("giro")
	tween.tween_property(self, "rotation_degrees:y", rotacion_destino, 0.5)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	
	pieza_colocada = true
	physics_material_override.bounce = 0
	gravity_scale=1


	
			
func animacion(anima):
	if animation_player:
		anima = str(pieza_tipo)+anima
		if animation_player.has_animation(anima):
			animation_player.play(anima)


func Sonido(tipo):
	var oleada_Sound = AudioStreamPlayer3D.new()
	var archivo_sonido = "res://assets/sound/sfx/"+tipo+".mp3"
	oleada_Sound.stream = load(archivo_sonido)
	oleada_Sound.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_SQUARE_DISTANCE
	oleada_Sound.unit_size = 10        # Se atenúa rápido
	oleada_Sound.max_distance = 30.0    # Fuera de 10 m ya no se escucha
	add_child(oleada_Sound)
	oleada_Sound.play()
	await oleada_Sound.finished
	oleada_Sound.queue_free()

func ataque(idA):
	if idA!=id:
		return
	var anima="Bataque"
	animacion(anima)

func recibeDanio(idD: int,danio: int):
	if idD!=id:
		return
	vida_actual -= danio
	
	if secuencia_sfx==0:  # para que os sonidos sean diversos y no suenen tan seguidos
		Sonido("hurt")
		secuencia_sfx +=1
		
		
	# actualizar barra de vida -------------------------------------------------
		
	
	# Sonido de daño - cargar los diferentes tipod de sonido
	#recibeDanio.play()
		
	if vida_actual <= 0:
		die()

func die():
	is_alive = false
	create_dust_effect()
	Sonidos.death()
	
	# Animación de muerte
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3.ZERO, 0.5)
	tween.tween_callback(queue_free)



func giro_remoto(pieza_id,angulo):
	if id!=pieza_id:
		return
	print (pieza_id," ",angulo)
	giro_rad(angulo)
	
func giro_rad(angulo):
	var _rotacion_actual = rotation_degrees.y
	var rotacion_destino = angulo
	var tween = create_tween()
	
	#calcular el giro mas corto
	Sonido("giro")
	tween.tween_property(self, "rotation:y", rotacion_destino, 0.5)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	
	
	pieza_colocada = true
	physics_material_override.bounce = 0
	gravity_scale=1
	
# ---------------------  auxilia borrar si no es necesario	


	
func look_at_target(pieza_id, target: Vector3):
	if id != pieza_id:
		return
	
	# Posición actual
	var pos = global_transform.origin
	
	# Ignorar el eje Y (mantener la altura actual)
	var target_flat = Vector3(target.x, pos.y, target.z)
	
	# Calcular la rotación objetivo
	var dir = (target_flat - pos).normalized()
	var target_basis = Basis.looking_at(dir, Vector3.UP)
	
	# Crear tween para la rotación suave
	var tween = create_tween()
	tween.tween_property(self, "global_transform", Transform3D(target_basis, pos), 1.0)
	
	# Alternativa: Tween solo la rotación (más eficiente)
	# var start_basis = global_transform.basis
	# tween.tween_method(_update_rotation.bind(start_basis, target_basis), 0.0, 1.0, 1.0)

# Método auxiliar para interpolación manual (opcional)
func _update_rotation(weight: float, start_basis: Basis, end_basis: Basis):
	var new_basis = start_basis.slerp(end_basis, weight)
	global_transform = Transform3D(new_basis, global_transform.origin)
