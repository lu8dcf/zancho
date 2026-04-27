extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func hurt():
	var hurt_sound = AudioStreamPlayer3D.new()
	hurt_sound.stream = preload("res://assets/sound/sfx/hurt.mp3")
	add_child(hurt_sound)
	hurt_sound.play()
	await hurt_sound.finished
	hurt_sound.queue_free()

func death():
	var death_sound = AudioStreamPlayer3D.new()
	death_sound.stream = preload("res://assets/sound/sfx/death.mp3")
	add_child(death_sound)
	death_sound.play()
	await death_sound.finished
	death_sound.queue_free()
	
func impacto():
	var death_sound = AudioStreamPlayer3D.new()
	death_sound.stream = preload("res://assets/sound/sfx/pieza_cae.mp3")
	add_child(death_sound)
	death_sound.volume_db = -10 + randf_range(-5, 5)
	death_sound.pitch_scale = 0.8 + randf_range(-0.2, 0.2)
	death_sound.play()
	await death_sound.finished
	death_sound.queue_free()
	
func menu(activar: bool):
	var death_sound: AudioStreamPlayer3D = null
	
	if activar:
		print ("play")
		# Crear solo si no existe (pero siempre se reinicia aquí)
		death_sound = AudioStreamPlayer3D.new()
		death_sound.stream = preload("res://assets/audio/music/TheTrueStoryofBeelzebub.ogg")
		add_child(death_sound)
		
		death_sound.volume_db = 0 + randf_range(-5, 5)
		death_sound.pitch_scale = 0.8 + randf_range(-0.2, 0.2)
		death_sound.play()
	else:
		print ("stop")
		if death_sound != null:
			await fade_out(death_sound, 1.0)
			death_sound.stop()
			death_sound.queue_free()
			death_sound = null

func fade_out(audio: AudioStreamPlayer3D, duration: float):
	var tween = create_tween()
	tween.tween_property(audio, "volume_db", -80.0, duration)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	await tween.finished
