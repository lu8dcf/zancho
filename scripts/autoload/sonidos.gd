extends Node

var musica_menu_global: AudioStreamPlayer = null

func _ready() -> void:
	crear_buses_audio()

func crear_buses_audio():
	var music_idx = AudioServer.get_bus_index("Music")
	var sfx_idx = AudioServer.get_bus_index("SFX")
	
	if music_idx == -1:
		AudioServer.add_bus()
		music_idx = AudioServer.bus_count - 1
		AudioServer.set_bus_name(music_idx, "Music")
		# Ponerlo debajo de Master
		AudioServer.set_bus_send(music_idx, "Master")
		print("✅ Bus 'Music' creado")
	
	if sfx_idx == -1:
		AudioServer.add_bus()
		sfx_idx = AudioServer.bus_count - 1
		AudioServer.set_bus_name(sfx_idx, "SFX")
		AudioServer.set_bus_send(sfx_idx, "Master")
		print("✅ Bus 'SFX' creado")

		
# 🆕 Función helper para crear sonidos en el bus correcto
func crear_audio_player(tipo: String = "SFX") -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	player.bus = tipo  # "Master", "Music" o "SFX"
	return player

func crear_audio_player_2d(tipo: String = "SFX") -> AudioStreamPlayer2D:
	var player = AudioStreamPlayer2D.new()
	player.bus = tipo
	return player

func crear_audio_player_3d(tipo: String = "SFX") -> AudioStreamPlayer3D:
	var player = AudioStreamPlayer3D.new()
	player.bus = tipo
	return player

# 🆕 Modificar sonar_sfx para usar el bus SFX
func sonar_sfx(archivo):
	var sound = crear_audio_player_3d("SFX")
	var direccion = "res://assets/sound/sfx/" + archivo + ".mp3"
	sound.stream = load(direccion)
	add_child(sound)
	sound.play()
	await sound.finished
	sound.queue_free()

func death():
	var death_sound = crear_audio_player_3d("SFX")
	death_sound.stream = preload("res://assets/sound/sfx/death.mp3")
	add_child(death_sound)
	death_sound.play()
	await death_sound.finished
	death_sound.queue_free()
	
func impacto():
	var impact_sound = crear_audio_player_3d("SFX")
	impact_sound.stream = preload("res://assets/sound/sfx/caida.mp3")
	add_child(impact_sound)
	impact_sound.volume_db = -10 + randf_range(-5, 5)
	impact_sound.pitch_scale = 0.8 + randf_range(-0.2, 0.2)
	impact_sound.play()
	await impact_sound.finished
	impact_sound.queue_free()
	
func menu(activar: bool):
	if activar:
		if musica_menu_global == null:
			var music_player = crear_audio_player("Music")  # 🆕 Usa bus Music
			music_player.stream = preload("res://assets/audio/music/TheTrueStoryofBeelzebub.ogg")
			add_child(music_player)
			
			var volumen_objetivo = -50.0
			music_player.volume_db = -80.0
			music_player.play()
			
			var tween_in = create_tween()
			tween_in.set_trans(Tween.TRANS_SINE)
			tween_in.set_ease(Tween.EASE_OUT)
			tween_in.tween_property(music_player, "volume_db", volumen_objetivo, 2.0)
			
			musica_menu_global = music_player
	else:
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
	var oleada_sound = crear_audio_player_3d("SFX")
	oleada_sound.stream = preload("res://assets/sound/sfx/CampanaOleada.mp3")
	add_child(oleada_sound)
	oleada_sound.play()
	await oleada_sound.finished
	oleada_sound.queue_free()
	
func compra():
	var compra_sound = crear_audio_player_3d("SFX")
	compra_sound.stream = preload("res://assets/sound/sfx/compra.mp3")
	add_child(compra_sound)
	compra_sound.play()
	await compra_sound.finished
	compra_sound.queue_free()

func ataque():
	var ataque_sound = crear_audio_player_3d("SFX")
	ataque_sound.stream = preload("res://assets/sound/sfx/horn.mp3")
	add_child(ataque_sound)
	ataque_sound.play()
	await ataque_sound.finished
	ataque_sound.queue_free()

func boton1():
	var boton_sound = crear_audio_player_2d("SFX")
	
	var sonidos = [
		preload("res://assets/sound/sfx/botones_interfaz/boton1.mp3"),
		preload("res://assets/sound/sfx/botones_interfaz/boton2.mp3"),
		preload("res://assets/sound/sfx/botones_interfaz/boton3.mp3"),
		preload("res://assets/sound/sfx/botones_interfaz/boton4.mp3")
	]
	
	boton_sound.stream = sonidos.pick_random()
	add_child(boton_sound)
	boton_sound.play()
	await boton_sound.finished
	boton_sound.queue_free()

func claim():
	var claim_sound = crear_audio_player_2d("SFX")
	claim_sound.stream = preload("res://assets/sound/sfx/botones_interfaz/claim.mp3")
	add_child(claim_sound)
	claim_sound.play()
	await claim_sound.finished
	claim_sound.queue_free()

func error():
	var error_sound = crear_audio_player_2d("SFX")
	error_sound.stream = preload("res://assets/sound/sfx/botones_interfaz/error.mp3")
	add_child(error_sound)
	error_sound.play()
	await error_sound.finished
	error_sound.queue_free()
	
func hover():
	var hover_sound = crear_audio_player_2d("SFX")
	hover_sound.stream = preload("res://assets/sound/sfx/botones_interfaz/hover.mp3")
	add_child(hover_sound)
	hover_sound.play()
	await hover_sound.finished
	hover_sound.queue_free()
