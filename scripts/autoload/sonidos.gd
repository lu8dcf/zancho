extends Node

# Única línea nueva: variable persistente para que el 'else' no falle nunca
var musica_menu_global: AudioStreamPlayer = null

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func death():
	var death_sound = AudioStreamPlayer3D.new()
	death_sound.stream = preload("res://assets/sound/sfx/death.mp3")
	add_child(death_sound)
	death_sound.play()
	await death_sound.finished
	death_sound.queue_free()
	
func impacto():
	var death_sound = AudioStreamPlayer3D.new()
	death_sound.stream = preload("res://assets/sound/sfx/caida.mp3")
	add_child(death_sound)
	death_sound.volume_db = -10 + randf_range(-5, 5)
	death_sound.pitch_scale = 0.8 + randf_range(-0.2, 0.2)
	death_sound.play()
	await death_sound.finished
	death_sound.queue_free()
	
func menu(activar: bool):
	var death_sound: AudioStreamPlayer = null 
	
	if activar:
		print ("play")
		if musica_menu_global == null:
			death_sound = AudioStreamPlayer.new()
			death_sound.stream = preload("res://assets/audio/music/TheTrueStoryofBeelzebub.ogg")
			add_child(death_sound)
			
	
			var volumen_objetivo = 0 + randf_range(-5, 5)
			death_sound.volume_db = -80.0
			death_sound.play()
			

			var tween_in = create_tween()
			tween_in.set_trans(Tween.TRANS_SINE)
			tween_in.set_ease(Tween.EASE_OUT)
			tween_in.tween_property(death_sound, "volume_db", volumen_objetivo, 2.0)
			
			musica_menu_global = death_sound
	else:
		print ("stop")
		if musica_menu_global != null:
			var musica_a_borrar = musica_menu_global
			musica_menu_global = null 
			
			await fade_out(musica_a_borrar, 6.0)
			
			musica_a_borrar.stop()
			musica_a_borrar.queue_free()

func fade_out(audio: AudioStreamPlayer, duration: float):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(audio, "volume_db", -80.0, duration)
	
	await tween.finished

func comienzoOleada():
	var oleada_Sound = AudioStreamPlayer3D.new()
	oleada_Sound.stream = preload("res://assets/sound/sfx/CampanaOleada.mp3")
	add_child(oleada_Sound)
	oleada_Sound.play()
	await oleada_Sound.finished
	oleada_Sound.queue_free()
	
func compra():
	var oleada_Sound = AudioStreamPlayer3D.new()
	oleada_Sound.stream = preload("res://assets/sound/sfx/compra.mp3")
	add_child(oleada_Sound)
	oleada_Sound.play()
	await oleada_Sound.finished
	oleada_Sound.queue_free()

func ataque():
	var oleada_Sound = AudioStreamPlayer3D.new()
	oleada_Sound.stream = preload("res://assets/sound/sfx/horn.mp3")
	add_child(oleada_Sound)
	oleada_Sound.play()
	await oleada_Sound.finished
	oleada_Sound.queue_free()
