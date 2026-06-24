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
		AudioServer.set_bus_send(music_idx, "Master")
	
	if sfx_idx == -1:
		AudioServer.add_bus()
		sfx_idx = AudioServer.bus_count - 1
		AudioServer.set_bus_name(sfx_idx, "SFX")
		AudioServer.set_bus_send(sfx_idx, "Master")

		
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

func sonar_sfx(archivo):
	if archivo=="muerte" or archivo=="caida":
		var opcion=randi() % 4
		archivo = archivo+"/"+archivo + str(opcion)
	var sound = crear_audio_player_3d("SFX")
	var direccion = "res://assets/sound/sfx/" + archivo + ".mp3"
	sound.stream = load(direccion)
	add_child(sound)
	sound.play()
	await sound.finished
	sound.queue_free()


	
func menu(activar: bool):
	if activar:
		if musica_menu_global == null:
			var music_player = crear_audio_player("Music")  
			music_player.stream = preload("res://assets/audio/music/TheTrueStoryofBeelzebub.ogg")
			add_child(music_player)
			

			var volumen_objetivo = -20.0
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
	var sonidos = [
		preload("res://assets/sound/sfx/botones_compra/compra1.mp3"),
		preload("res://assets/sound/sfx/botones_compra/compra2.mp3"),
		preload("res://assets/sound/sfx/botones_compra/compra3.mp3")
	]
	
	compra_sound.stream = sonidos.pick_random()
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

func venta():
	var venta_sound = crear_audio_player_2d("SFX")
	venta_sound.stream = preload("res://assets/sound/sfx/botones_interfaz/venta.mp3")
	add_child(venta_sound)
	venta_sound.play()
	await venta_sound.finished
	venta_sound.queue_free()
	
func hover():
	var hover_sound = crear_audio_player_2d("SFX")
	var sonidos = [
		preload("res://assets/sound/sfx/botones_interfaz/hover.mp3")
	]
	
	hover_sound.stream = sonidos.pick_random()
	add_child(hover_sound)
	hover_sound.play()
	await hover_sound.finished
	hover_sound.queue_free()
