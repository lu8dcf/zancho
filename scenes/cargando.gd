extends CanvasLayer

signal pantalla_carga_barra_lleno

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = $Panel/ProgressBar


func _actualiza_progreso_barra(nuevo_valor: float):
	var porcentaje = clamp(nuevo_valor * 100, 0, 100)
	progress_bar.value = porcentaje
	
func _empieza_animacion():
	animation_player.play("termina_carga")
	pantalla_carga_barra_lleno.emit()
	await animation_player.animation_finished
	
