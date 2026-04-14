extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	death_sound.play()
	await death_sound.finished
	death_sound.queue_free()
