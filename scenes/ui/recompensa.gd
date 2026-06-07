extends Control

@onready var play: MenuBar = $"../play"
@onready var opciones: MenuBar = $"../opciones"
@onready var panel: TextureRect = $panel
@onready var imagen_recompensa: TextureButton = $imagen_recompensa
@onready var recompensa: Control = $"."

@onready var brillo = $brillo

var tiempo := 0.0
var animar := true
var posicion_original : Vector2

func _ready() -> void:
	panel.visible = false
	iniciar_animacion_recompensa()
	imagen_recompensa.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	
func _process(delta):
	if animar:
		tiempo += delta

		var brillo_scale = 1.0 + sin(tiempo * 2.0) * 0.05
		brillo.scale = Vector2.ONE * brillo_scale

		brillo.modulate.a = 0.8 + sin(tiempo * 2.0) * 0.2

func iniciar_animacion_recompensa():
	while animar:

		# Espera entre animaciones
		await get_tree().create_timer(randf_range(2.0, 4.0)).timeout

		if !animar:
			break

		var tween = create_tween()

		# Agranda
		tween.tween_property(
			imagen_recompensa,
			"scale",
			Vector2(1.15, 1.15),
			0.15
		)

		# Vuelve al tamaño normal
		tween.tween_property(
			imagen_recompensa,
			"scale",
			Vector2.ONE,
			0.15
		)

		# Pequeña sacudida
		tween.parallel().tween_property(
			imagen_recompensa,
			"rotation_degrees",
			5,
			0.08
		)

		tween.tween_property(
			imagen_recompensa,
			"rotation_degrees",
			-5,
			0.08
		)

		tween.tween_property(
			imagen_recompensa,
			"rotation_degrees",
			0,
			0.08
		)
	
func _on_imagen_recompensa_pressed() -> void:
	animar = false

	imagen_recompensa.rotation_degrees = 0
	imagen_recompensa.scale = Vector2.ONE

	panel.visible = true
	opciones.visible = false
	play.visible = false
	


func _on_continuar_pressed() -> void:
	economia.añadir_monedas(500)
	await get_tree().create_timer(1.0).timeout
	recompensa.visible = false	

func _on_rechazar_pressed() -> void:
	recompensa.visible = false	
