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
var vida_total: int
var vida_actual: int
var angulo_frente: int = 225 # por defecto la negra

# Componentes
var movimiento_especifico = preload("res://scenes/pieza/movimiento/movimiento.tscn") # define le movimiento caracteristico de la pieza
var ataque_especifico = preload("res://scenes/pieza/ataque/Ataque.tscn") # define le movimiento caracteristico de la pieza

# Nodos
@onready var dust_particles = $DustParticles
@onready var giro_inicial = $GiroInicial
@onready var area_ataque: Area3D = $AreaAtaque

# Contenedor par acargar escena del modelo
@onready var contenedor : Node3D = $Contenedor # contenedor modelo imagen y funciones
@onready var contenedor_ataque : Node3D = $ContenedorAtaque # contenedor modelo imagen y funciones

# Referencia a la instancia de la pieza (con AnimationPlayer)
var instancia_objeto_pieza: Node3D
var animation_player : AnimationPlayer
@onready var area_interaccion : Area3D = $AreaInteraccion
var modelo : PackedScene


# Variables de estado

var color="N"
var pieza_colocada=false
var pieza : Resource
#var secuencia_sfx = randi() % 3# secuencia de sonido

# barra de vida
signal barraVida(porcentual)
@onready var barra = $Marker3D/barra
@onready var sangre = $sangre/AnimationPlayer
@onready var nodo_sangre = $sangre

func _ready():
	vida_total = Piezas.vida[pieza_tipo]
	vida_actual = vida_total
	
	if pieza_blanca: color="B" 	
	
	pieza = load("res://scripts/resource/pieza"+ str(pieza_tipo) + color +".tres")
	
	# Configurar física
	linear_velocity = Vector3(0, linear_velocity.y, 0)  # que no se mueva a los costados
	#rebote
	physics_material_override.bounce =.3
	gravity_scale = 2.0
	cargar_modelo()
	#cargar_objeto() # Asigna el modelo y objero con sus animaciones			
	posicionamiento_giro() # gira la pieza a su posicion en grados
	
	cargar_movimiento() # Script de movimiento y estados
	cargar_ataque() # Scrip de zona de ataque
	animacion("Bidle")
	conectar_señales()
	
	# señales de control	
	GlobalSignal.connect("giro_pieza",giro_remoto)
	GlobalSignal.connect("piezaAtaca",ataque)
	GlobalSignal.connect("piezaRecibeDanio",recibeDanio)
	GlobalSignal.connect("finalizaOleada",finalizaOleada)

func cargar_modelo():
	modelo = load("res://assets/modelos/pieza_generica/pieza_"+ str(pieza_tipo)+".tscn")
	instancia_objeto_pieza = modelo.instantiate()
	
	# agrega el material correspondiente al color
	if pieza_blanca: 
		instancia_objeto_pieza.material = Piezas.material_bueno
	else:
		instancia_objeto_pieza.material = Piezas.material_malo
	# le paso el id a la textura para que sepa cuando cambiar a nmuerte
	instancia_objeto_pieza.id=id
		
	
	contenedor.add_child(instancia_objeto_pieza)
	# Buscar el AnimationPlayer dentro de esta instancia
	animation_player = _find_animation_player(instancia_objeto_pieza)

func cargar_objeto():# Instanciar y agregar al contenedor
	instancia_objeto_pieza = pieza.modelo.instantiate()
	contenedor.add_child(instancia_objeto_pieza)
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
	movimiento.owner = self  #  Establece el owner manualmente

func cargar_ataque(): # agrega el nodo ataque con el script correspondiente a la pieza
	var ataque_pieza = ataque_especifico.instantiate()
	var ataque_script = "res://scenes/pieza/ataque/ataque1.gd"
	var script = load(ataque_script)
	ataque_pieza.set_script(script)
	add_child(ataque_pieza)
	ataque_pieza.owner = self  #  Establece el owner manualmente
		
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
	create_dust_effect()# Efecto de polvo
	Sonidos.impacto()# Sonido de golpe
	pieza_colocada=true # que no vuelva a generar el sonido de caida
	
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
	angulo_frente=angulo
	var tween = create_tween()
	var _rotacion_actual = rotation_degrees.y
	var rotacion_destino = angulo
	
	#calcular el giro mas corto
	if pieza_tipo !=4 and pieza_blanca==false: # evita que el caballo negro suene mucho al andar
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

func Sonido(tipo): # funcion generica pra los sonidos de la pieza
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
	
	animacion("Bataque")
	await get_tree().create_timer(0.5).timeout
	Sonido("espada2")
	
# -------------------------------   esto hay que pasarlo a la barra d evida ------------------------
func recibeDanio(idD: int,danio: int):
	if idD!=id:
		return
	nodo_sangre.visible=true
	vida_actual -= danio
	await get_tree().create_timer(0.7).timeout
	Sonido("danio")
	sangre.play("Sangre")
	
		
	
		
		
	# calculo del porcentaje de vida 
	var porcentaje = float(vida_actual) / vida_total
	barraVida.emit(porcentaje)
			
	if vida_actual <= 0:
		die()

func die():
	GlobalSignal.piezaMuere.emit(id) # aviso que muere
	# Efectos de muerte
	Sonidos.death()
	animacion_muerte()
	
func animacion_muerte():
	freeze = true
	gravity_scale = 0
	# elimina la instancia de la lista
	if Piezas.pieza_blanca.has(self):  # elimina su instancia si es blanca
		Piezas.pieza_blanca.erase(self)
	if Piezas.pieza_negra.has(self):   # elimina su instancia si es negra
		Piezas.pieza_negra.erase(self)	
		
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Subir y rotar lentamente
	tween.tween_property(self, "global_position:y", global_position.y + 5 ,3)
	#tween.tween_property(self, "rotation:y", rotation.y + 10, 2)  # Girar mientras sube
	#tween.tween_property(self, "scale", Vector3.ZERO, 3)
		
	await tween.finished
	
	
	if Piezas.pieza_negra.size()==0:
		GlobalSignal.finalizaOleada.emit(true)
	
	if pieza_tipo==0:
		GlobalSignal.finalizaOleada.emit(false)
	queue_free()

func finalizaOleada(_estado):
	queue_free()

func giro_remoto(pieza_id,angulo): # angulo en radianes
	if id!=pieza_id:
		return
	
	# señal que la batalla finalizo y esta pieza es la ganadora debe volver a la posicion inicial
	if angulo==1000:  
		giro(angulo_frente)
		return
	
	giro_rad(angulo)
	
func giro_rad(angulo):
	var tween = create_tween()
		
	Sonido("giro")
	tween.tween_property(self, "rotation:y", angulo, 0.5)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
		
	pieza_colocada = true
	physics_material_override.bounce = 0
	gravity_scale=1
	
#Acciones del jugador	
func conectar_señales():
	if area_interaccion:
		area_interaccion.mouse_entered.connect(_al_entrar_mouse)
		area_interaccion.mouse_exited.connect(_al_salir_mouse)
		# CLIC DEL MOUSE (input_event)
		area_interaccion.input_event.connect(_al_evento_input)
		
# Over sobre la pieza
func _al_entrar_mouse():
	GlobalSignal.overPieza.emit(true,pieza_tipo,round(global_position/espaciado))
	
#salir del over
func _al_salir_mouse():
	GlobalSignal.overPieza.emit(false,pieza_tipo,round(global_position/espaciado))
	
#click sobre la pieza emn esrte caso busca la reina blanca	
func _al_evento_input(_viewport, event, _shape_idx,_a,_b):
	# Detectar CLIC IZQUIERDO
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:  # Cuando se presiona el botón
			if pieza_tipo==5 and pieza_blanca==true:
				GlobalSignal.clickReina.emit()
			
				
				#print("CLIC IZQUIERDO detectado en el Area2D ",pieza_tipo )
			
	
