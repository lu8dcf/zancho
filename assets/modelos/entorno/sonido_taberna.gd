extends Area3D

@onready var taberna: AudioStreamPlayer3D = $taberna



func _ready() -> void:
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:

	if body is CharacterBody3D:
		taberna.play()


func _on_body_exited(_body: Node3D) -> void:
	taberna.stop()
