extends Area3D


@onready var iglesia: AudioStreamPlayer3D = $iglesia


func _ready() -> void:
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:

	if body is CharacterBody3D:
		iglesia.play()


func _on_body_exited(body: Node3D) -> void:
	iglesia.stop()
