extends Control

	


func _on_reanudar_pressed() -> void:
	$AnimationPlayer.play_backwards("ganaste la oldeada")
	

func _on_menu_pressed() -> void:
	GlobalSignal.emit_signal("aceleraMarcaPaso",3)
	GlobalSignal.emit_signal("controlMarcaPaso",true)
	get_tree().change_scene_to_file("res://scenes/ui/main.tscn")


func _on_reinicar_pressed() -> void:
	pass # Replace with function body.


func _on_opciones_pressed() -> void:
	pass # Replace with function body.
