extends Node

const CURSOR_1 = preload("res://assets/ui/cursores/cursor1.png")  # normal
const CURSOR_2 = preload("res://assets/ui/cursores/cursor2.png")  # click
const CURSOR_3 = preload("res://assets/ui/cursores/cursor3.png")  # agarrar
const CURSOR_4 = preload("res://assets/ui/cursores/cursor4.png")  # manito arriba

var cursor_actual: Resource
var escala_cursor: float = 0.5  # Escala por defecto (0.5 = mitad del tamaño)

var texturas_escaladas: Dictionary = {}

var cursor_temporal_activo: bool = false
var temporizador_cursor: Timer = null


func _ready():
	temporizador_cursor = Timer.new()
	temporizador_cursor.one_shot = true
	temporizador_cursor.timeout.connect(_restaurar_cursor_normal)
	add_child(temporizador_cursor)

	cambiar_cursor(CURSOR_1, Vector2(0, 0))
	Piezas.pieza_colocada_inventario.connect(cambiar_cursor_manito)
	

func _process(_delta: float) -> void:
	if cursor_temporal_activo:
		return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		cambiar_cursor(CURSOR_2, Vector2(0, 0))
	elif Piezas.modo_colocacion:
		cambiar_cursor(CURSOR_3, Vector2(0, 0))	
	else:
		cambiar_cursor(CURSOR_1, Vector2(0, 0))
		
func cambiar_cursor_manito(_valor):
	cursor_temporal_activo = true
	
	cambiar_cursor(CURSOR_4, Vector2(0, 0))
	temporizador_cursor.start(1.0)


func cambiar_cursor(textura: Texture2D, hotspot: Vector2 = Vector2(0, 0)):
	if textura == null:
		return
	
	var textura_escalada = obtener_textura_escalada(textura, escala_cursor)
	
	Input.set_custom_mouse_cursor(
		textura_escalada,
		Input.CURSOR_ARROW,
		hotspot * escala_cursor 
	)
	cursor_actual = textura

func _restaurar_cursor_normal():
	cursor_temporal_activo = false
	if Piezas.modo_colocacion:
		cambiar_cursor(CURSOR_3, Vector2(0, 0))
	else:
		cambiar_cursor(CURSOR_1, Vector2(0, 0))


func obtener_textura_escalada(textura_original: Texture2D, escala: float) -> ImageTexture:
	var clave_cache = str(textura_original.get_rid()) + "_" + str(escala)
	
	if texturas_escaladas.has(clave_cache):
		return texturas_escaladas[clave_cache]
	
	var imagen_original = textura_original.get_image()
	
	var nuevo_ancho = int(imagen_original.get_width() * escala)
	var nuevo_alto = int(imagen_original.get_height() * escala)
	
	nuevo_ancho = max(1, nuevo_ancho)
	nuevo_alto = max(1, nuevo_alto)
	
	imagen_original.resize(nuevo_ancho, nuevo_alto, Image.INTERPOLATE_LANCZOS)
	
	var textura_escalada = ImageTexture.create_from_image(imagen_original)
	
	texturas_escaladas[clave_cache] = textura_escalada
	
	return textura_escalada


func cambiar_escala_cursor(nueva_escala: float):
	
	
	escala_cursor = nueva_escala
	texturas_escaladas.clear()
	
	if cursor_actual:
		cambiar_cursor(cursor_actual, Vector2(0, 0))



func escala_pequeña():
	cambiar_escala_cursor(0.4)  # Mitad del tamaño

func escala_normal():
	cambiar_escala_cursor(0.75)  # 75% del tamaño original

func escala_grande():
	cambiar_escala_cursor(1.0)  # Tamaño original

func escala_muy_grande():
	cambiar_escala_cursor(1.5)  # 150% del tamaño
